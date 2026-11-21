# Monthly World News: build brief

## Goal
Build a retro-magazine style "World News" and "Charts" viewer covering every month from **January 1970 to December 2010**. All content is researched once, with sources, and saved as data files. The app only reads the files. It must never call an AI service while browsing.

## Files to produce
- `data/YYYY-MM.json`: one file per month (492 files), same structure as `1996-11.json`.
- `index.html`: the viewer. Start from `world-news-mockup.html`, but load the month's file with `fetch("data/YYYY-MM.json")` instead of the embedded sample. This needs hosting (for example GitHub Pages), because `fetch` does not work from a local file.
- `scripts/validate.py` (or similar): checks every file and prints a report.

## Data structure (per month)
- `month`, `region` ("UK").
- `news[]`: `id`, `date` (YYYY-MM-DD, must fall inside the month), `topic`, `text`, `wiki` (English Wikipedia title), `youtube` (search phrase), `source` (URL), `edition`, `confidence` (`high`, `medium`, `low`), `importance` (1 to 5).
- `charts[]`: `section`, `kind` (`games` or `music`), `entries[]` with `pos`, `title`, `by`. Add `source` (URL) per section.
- Topics allowed: `business`, `film`, `music`, `deaths`, `politics`, `science`, `sport`, `tech`, `games`, `wrestling`.
- Each month is a **pool** of 5 to 12 candidate stories, not a fixed article. The viewer picks the best per topic using the user's topic priorities and shows different stories on request.

## Writing style
- One paragraph per item, 2 to 4 sentences, British spelling, informative and slightly wry.
- Start with the day and month: "7 November saw...". Put 2 to 4 keywords in `**bold**`. Put titles of films, shows, albums and games in `*italics*`.
- Write in your own words. Do not copy text from sources.

## Accuracy rules (most important)
1. **No item from memory alone.** Every item needs at least one source URL that you actually opened and that supports the date and the key facts.
2. Confirm the date and at least one other detail in a second source where possible. If sources disagree, set `confidence: "low"` or drop the item.
3. **Never describe a match, result, score or quote** unless a source states it.
4. **Wrestling:** include an item only if a reliable source gives the event name, date and result. Otherwise leave wrestling out for that month. Check that people and titles existed at that date (for example, who was actually in the company then).
5. **Charts:** use real chart sources (for example the Official Charts Company for singles, Wikipedia or magazine archives for games). If no reliable chart exists for a platform that month, leave `entries` empty. Do not invent rankings or substitute "plausible" titles. Only list platforms that were current that month.
6. Skip a topic for a month if nothing solid is found. A short accurate month is better than a full doubtful one.

## Process
1. **Pilot first:** do `1988-02`, `1991-03` and `1996-10`, and show the sources for every item before continuing. (1988-02 and 1991-03 had wrong wrestling and film details in an earlier AI-written version, so they are good tests.)
2. After approval, work **one year at a time**, committing after each year.
3. Run the validator after each year. It should check: valid JSON, dates inside the month, topics from the allowed list, unique ids, every item has a source URL, no empty `text`.
4. At the end of each year, list the items marked `low` confidence and all wrestling items for human review.
5. If usage limits are hit, stop and resume later from the next unfinished month. Keep a `PROGRESS.md` listing finished months.

## Later (not part of this build)
Package as a home-screen app or Android app, and an EPUB export of a chosen year.
