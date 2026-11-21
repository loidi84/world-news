#!/usr/bin/env python3
"""
Validator for World News monthly data files.
Checks JSON validity, dates, topics, unique IDs, source URLs, and data structure.
"""

import sys
import os
import json
import re
from datetime import datetime
from pathlib import Path

ALLOWED_TOPICS = {
    "business", "film", "music", "deaths", "politics",
    "science", "sport", "tech", "games", "wrestling"
}

ALLOWED_CONFIDENCE = {"high", "medium", "low"}
ALLOWED_CHART_KINDS = {"games", "music", "film", "cinema"}

def validate_month_file(filepath: Path):
    errors = []
    warnings = []
    wrestling_items = []
    low_confidence_items = []

    filename = filepath.name
    match = re.match(r"^(\d{4})-(\d{2})\.json$", filename)
    if not match:
        errors.append(f"Filename '{filename}' does not match expected format YYYY-MM.json")
        return errors, warnings, wrestling_items, low_confidence_items

    expected_year, expected_month = int(match.group(1)), int(match.group(2))
    if not (1 <= expected_month <= 12):
        errors.append(f"Month {expected_month} out of range 1-12 in {filename}")

    try:
        with open(filepath, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception as e:
        errors.append(f"Invalid JSON in {filename}: {e}")
        return errors, warnings, wrestling_items, low_confidence_items

    # Root fields
    if data.get("month") != f"{expected_year:04d}-{expected_month:02d}":
        errors.append(f"Root field 'month' ({data.get('month')}) does not match filename {filename}")

    if data.get("region") != "UK":
        warnings.append(f"Root field 'region' is '{data.get('region')}', expected 'UK'")

    # News items
    news = data.get("news")
    if not isinstance(news, list):
        errors.append(f"'news' must be a list in {filename}")
        news = []

    seen_ids = set()
    for idx, item in enumerate(news):
        item_id = item.get("id")
        if not item_id:
            errors.append(f"News item #{idx} missing 'id'")
        elif item_id in seen_ids:
            errors.append(f"Duplicate news id '{item_id}' in {filename}")
        else:
            seen_ids.add(item_id)

        # Date validation
        date_str = item.get("date")
        if not date_str:
            errors.append(f"News item '{item_id}' missing 'date'")
        else:
            try:
                item_date = datetime.strptime(date_str, "%Y-%m-%d")
                if item_date.year != expected_year or item_date.month != expected_month:
                    errors.append(f"Date '{date_str}' in item '{item_id}' is outside month {expected_year:04d}-{expected_month:02d}")
            except ValueError:
                errors.append(f"Date '{date_str}' in item '{item_id}' is not in YYYY-MM-DD format")

        # Topic validation
        topic = item.get("topic")
        if not topic:
            errors.append(f"Item '{item_id}' missing 'topic'")
        elif topic not in ALLOWED_TOPICS:
            errors.append(f"Topic '{topic}' in item '{item_id}' is not one of the allowed topics: {sorted(ALLOWED_TOPICS)}")

        if topic == "wrestling":
            wrestling_items.append((filename, item_id, item.get("text", "")[:60]))

        # Text validation
        text = item.get("text")
        if not text or not isinstance(text, str) or not text.strip():
            errors.append(f"Item '{item_id}' has empty or invalid 'text'")
        else:
            if "\n" in text.strip():
                warnings.append(f"Item '{item_id}' has multiple paragraphs; brief specifies one paragraph")

        # Wiki and Youtube
        if not item.get("wiki"):
            warnings.append(f"Item '{item_id}' missing 'wiki' title")
        if not item.get("youtube"):
            warnings.append(f"Item '{item_id}' missing 'youtube' query")

        # Source URL
        source = item.get("source")
        if not source:
            errors.append(f"Item '{item_id}' missing 'source'")
        elif not (source.startswith("http://") or source.startswith("https://") or source.startswith("Supplied page")):
            warnings.append(f"Item '{item_id}' source '{source}' does not look like a URL or supplied page")

        # Confidence
        confidence = item.get("confidence")
        if confidence and confidence not in ALLOWED_CONFIDENCE:
            errors.append(f"Item '{item_id}' confidence '{confidence}' not in {ALLOWED_CONFIDENCE}")
        if confidence == "low":
            low_confidence_items.append((filename, item_id, item.get("text", "")[:60]))

        # Importance
        importance = item.get("importance")
        if importance is not None:
            if not isinstance(importance, int) or not (1 <= importance <= 5):
                errors.append(f"Item '{item_id}' importance '{importance}' must be an integer between 1 and 5")

    # Pool size warning
    if len(news) < 4:
        warnings.append(f"{filename} has only {len(news)} news items (pool should ideally be 5-12)")

    # Charts validation
    charts = data.get("charts")
    if charts is not None:
        if not isinstance(charts, list):
            errors.append(f"'charts' must be a list in {filename}")
        else:
            for c_idx, chart in enumerate(charts):
                section = chart.get("section")
                kind = chart.get("kind")
                if not section:
                    errors.append(f"Chart #{c_idx} in {filename} missing 'section'")
                if kind not in ALLOWED_CHART_KINDS:
                    errors.append(f"Chart '{section}' in {filename} kind '{kind}' not in {ALLOWED_CHART_KINDS}")
                
                entries = chart.get("entries")
                if not isinstance(entries, list):
                    errors.append(f"Chart '{section}' in {filename} 'entries' must be a list")
                else:
                    for e_idx, entry in enumerate(entries):
                        if not isinstance(entry.get("pos"), int):
                            errors.append(f"Chart '{section}' entry #{e_idx} missing integer 'pos'")
                        if not entry.get("title"):
                            errors.append(f"Chart '{section}' entry #{e_idx} missing 'title'")
                        if not entry.get("by"):
                            errors.append(f"Chart '{section}' entry #{e_idx} missing 'by'")

    return errors, warnings, wrestling_items, low_confidence_items

def main():
    target_dir = Path("data")
    if len(sys.argv) > 1:
        target_dir = Path(sys.argv[1])

    if not target_dir.exists():
        print(f"Error: Directory '{target_dir}' does not exist.")
        sys.exit(1)

    files = sorted(target_dir.glob("*.json"))
    if not files:
        print(f"No JSON files found in '{target_dir}'.")
        sys.exit(0)

    total_files = len(files)
    total_errors = 0
    total_warnings = 0
    all_wrestling = []
    all_low_conf = []

    print(f"Validating {total_files} file(s) in '{target_dir}'...\n")

    for f in files:
        errs, warns, wrestling, low_conf = validate_month_file(f)
        all_wrestling.extend(wrestling)
        all_low_conf.extend(low_conf)

        if errs:
            total_errors += len(errs)
            print(f"[FAIL] {f.name}:")
            for e in errs:
                print(f"  - ERROR: {e}")
        elif warns:
            total_warnings += len(warns)
            print(f"[WARN] {f.name}:")
            for w in warns:
                print(f"  - WARNING: {w}")
        else:
            print(f"[OK]   {f.name}")

    print("\n" + "=" * 50)
    print(f"Summary: {total_files} files checked. {total_errors} error(s), {total_warnings} warning(s).")
    
    if all_wrestling:
        print(f"\n--- Wrestling Items ({len(all_wrestling)}) for Human Review ---")
        for fn, iid, txt in all_wrestling:
            print(f"  [{fn}] {iid}: {txt}...")

    if all_low_conf:
        print(f"\n--- Low Confidence Items ({len(all_low_conf)}) ---")
        for fn, iid, txt in all_low_conf:
            print(f"  [{fn}] {iid}: {txt}...")

    if total_errors > 0:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == "__main__":
    main()
