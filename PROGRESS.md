# World News Build Progress

## Status
- **Completed Eras:**
  - **1987:** June to December (all 7 months complete)
  - **1988:** January to December (all 12 months complete)
  - **1989:** January to December (all 12 months complete)
  - **1990:** January to December (all 12 months complete)
  - **1998:** January to December (all 12 months complete)
  - **Pilots & Samples:** 1991-03, 1996-10, 1996-11
- **Total Archive Size:** 58 fully validated monthly datasets complete with **World News, Full Triple Charts (Music, Games & Cinema Box Office), and Gaming Spotlight** tabs.
- **Offline Bundle:** `data/bundle.js` dynamically compiled and up to date with all 58 months.
- **Validators:** `scripts/validate.ps1` passing with 0 errors and 0 warnings.
- **UI Features:**
  - 4-Tab Bar (News, Gaming Spotlight, Charts, and ★ Saved Scrapbook) with pagination (`PAGE 1 OF X`) and chronological story ordering.
  - Swipe Gestures to Turn Pages: Natural mobile touch swipe left/right to turn pages in News or flip forward/backward across months.
  - 100% Offline PWA (Service Worker): `sw.js` pre-caches the app shell, icons, and `data/bundle.js` for instant, offline browsing on mobile devices.
  - Cinema Box Office Top 3: Charts tab features verified UK cinema box office across all 58 months alongside singles and video game charts, complete with links to film articles and YouTube trailers.
  - Wrestling Story Tag & Chronicle Filter: Dedicated `🤼 Wrestling Only` toggle in the News header (or via the `WRESTLING` story tag). If a month has no wrestling event, it offers direct 1-tap navigation to the nearest previous and next historical pay-per-views.
  - Favorites / Scrapbook: Star button (`☆ Save`) on every news story and gaming spotlight to pin favorite moments to a dedicated `★ Saved` scrapbook stored in `localStorage`, complete with 1-click jump-back links.
  - Dark Mode: Quick toggle (`🌙 / ☀️`) in control bar, settings dropdown (System / Light / Dark), custom dark paper palette (`--paper: #222226`, `--paper-ink: #f0ede6`), dynamic mobile `<meta name="theme-color">` sync, and `localStorage` persistence.
  - Cleaned Settings: Removed obsolete "Edition" dropdown and dummy "Export EPUB" placeholder.
  - Editorial Topic Badges: Replaced generic "RESEARCHED" tag with actual newspaper section slugs (`POLITICS`, `FILM & TV`, `MUSIC`, `GAMES`, `WRESTLING`, etc.).
  - Topic Controls: Simple On / Off toggles in Settings for each topic with `localStorage` persistence.
  - Dynamic Date Dropdowns: Year dropdown dynamically populates from available data (`1987, 1988, 1989, 1990, 1991, 1996, 1998`). Selecting a year dynamically filters the Month dropdown to only populated months (e.g. 1987 shows June–December; 1991 shows March; 1996 shows October–November; 1988, 1989, 1990, and 1998 show all 12 months). Month-to-month arrow buttons (`←` / `→`) retain normal calendar stepping.
  - Link Deduplication: Automatically suppresses redundant "Source" links when the source is Wikipedia (linking directly to the Wikipedia article instead), while displaying "Source ↗" for external citations (e.g. BBC, Official Charts, archives).

## Completed Months (58 total)
| Month | Status | Stories | Charts | Spotlight Game | Notes |
|-------|--------|---------|--------|----------------|-------|
| 1987-06 | Done | 7 | 2 | *Barbarian: The Ultimate Warrior* | Honky Tonk Man IC title, Thatcher 3rd win, Predator, Reagan Berlin wall, Star Trekkin' |
| 1987-07 | Done | 7 | 2 | *Paperboy* | First WarGames, 5 Billion Day, Taiwan martial law, RoboCop, Madonna #1 |
| 1987-08 | Done | 7 | 2 | *Street Fighter* (Arcade) | Flight 255 survivor, Rudolf Hess death, Hungerford, Rick Astley debut, Bad |
| 1987-09 | Done | 5 | 2 | *Renegade* | Randy Savage King of Ring, Goiania disaster, Montreal Protocol, Star Trek TNG |
| 1987-10 | Done | 6 | 2 | *PC Engine / Turbografx-16* | Mega Powers form, Great Storm (Michael Fish), Bee Gees #1, Black Monday, Grand Prix Simulator |
| 1987-11 | Done | 6 | 2 | *Joe Blade* | Enniskillen, T'Pau #1, King's Cross fire, Planes Trains Automobiles, Survivor Series |
| 1987-12 | Done | 7 | 2 | *Mega Man* | INF Treaty, First Intifada, Final Fantasy, Out Run #1, Pet Shop Boys Xmas #1, Dona Paz |
| 1988-01 | Done | 6 | 2 | *Platoon* | Perestroika, Chiang death, Belinda Carlisle #1, First Royal Rumble, Australian Bicentenary |
| 1988-02 | Done | 8 | 3 | *R-Type* | Hogan vs Andre, Red Dwarf, Eddie the Eagle, Kylie #1 |
| 1988-03 | Done | 6 | 2 | *Target: Renegade* | Operation Flavius, Milltown Cemetery, Corporals killings, Aswad #1, WrestleMania IV |
| 1988-04 | Done | 5 | 2 | *Super Mario Bros. 2* | Geneva Accords, Totoro / Fireflies, Pet Shop Boys Heart #1, Aloha Flight 243, Celine Dion Eurovision |
| 1988-05 | Done | 5 | 2 | *Wasteland* | Wimbledon Crazy Gang FA Cup, Soviet Afghan exit, Wet Wet Wet #1, Section 28, Reagan Moscow summit |
| 1988-06 | Done | 5 | 2 | *Bionic Commando* | Mandela 70th Birthday, Bros #1, Roger Rabbit, Van Basten Euro 88 volley, Rambo III |
| 1988-07 | Done | 5 | 2 | *The New Zealand Story* | Iran Air 655, Piper Alpha, Die Hard premiere, Glenn Medeiros #1, Flair vs Luger Great American Bash |
| 1988-08 | Done | 5 | 2 | *Super Team Games* | Burma 8888, Zia-ul-Haq plane crash, Iran-Iraq ceasefire, Yazz Acid House #1, SummerSlam Mega Powers |
| 1988-09 | Done | 5 | 2 | *RoboCop* (Ocean) | Seoul Olympics, Hollies Miller Lite #1, Ben Johnson doping scandal, Discovery Return to Flight, Daley Thompson |
| 1988-10 | Done | 5 | 2 | *Sega Mega Drive / Genesis* | Chile NO plebiscite, Sinn Fein broadcast ban, Enya Orinoco Flow #1, Operation Wolf |
| 1988-11 | Done | 5 | 2 | *Ultima V: Warriors of Destiny* | Morris worm, George Bush election win, Buran space shuttle, Robin Beck Coke #1, Survivor Series Mega Powers |
| 1988-12 | Done | 5 | 2 | *Ghouls 'n Ghosts* | Spitak Armenia earthquake, Clapham rail crash, Cliff Richard Xmas #1, Lockerbie Pan Am 103, Operation Wolf #1 |
| 1989-01 | Done | 6 | 2 | *Populous* | George H.W. Bush inauguration, Big John Studd Royal Rumble, Ted Bundy execution, Kylie Minogue #1, Polish Round Table |
| 1989-02 | Done | 6 | 2 | *Strider* (Arcade) | Mega Powers Explode (NBC), Soviet withdrawal from Afghanistan, Rushdie Satanic Verses fatwa, Marc Almond & Gene Pitney #1 |
| 1989-03 | Done | 6 | 2 | *SimCity* | Tim Berners-Lee WWW proposal, Exxon Valdez oil spill, Madonna Like a Prayer, Australian solar geomagnetic storm |
| 1989-04 | Done | 6 | 2 | *Game Boy* (Nintendo) | WrestleMania V (Hulkamania rules again), Hillsborough disaster, Hu Yaobang death (Tiananmen sparks) |
| 1989-05 | Done | 6 | 2 | *Wonder Boy III: The Dragon's Trap* | Iron Curtain fence cut in Hungary, Flair vs Steamboat WrestleWar trilogy climax, Tiananmen martial law |
| 1989-06 | Done | 6 | 2 | *Tetris* (Game Boy) | Tiananmen Square crackdown, Polish Solidarity election triumph, Tim Burton Batman, Jason Donovan #1 |
| 1989-07 | Done | 6 | 2 | *Prince of Persia* | Great American Bash (Flair vs Funk), Jive Bunny #1, Soyuz TM-8, Barksdale plane crash |
| 1989-08 | Done | 6 | 2 | *North & South* (Infogrames) | Voyager 2 Neptune flyby, Baltic Way human chain, SummerSlam (Hogan & Beefcake vs Savage & Zeus) |
| 1989-09 | Done | 6 | 2 | *Castlevania III: Dracula's Curse* | Blackline / Pan-European Picnic border opening, Black Box Ride on Time #1, Hurricane Hugo |
| 1989-10 | Done | 6 | 2 | *Space Quest III: The Pirates of Pestulon* | Loma Prieta World Series earthquake, Halloween Havoc Thunderdome, Nigel Lawson resigns, Jive Bunny #1 |
| 1989-11 | Done | 6 | 2 | *Super Mario Land* | Fall of the Berlin Wall (9 Nov), Velvet Revolution in Prague, Survivor Series Hulkamaniacs |
| 1989-12 | Done | 6 | 2 | *Golden Axe* (Arcade) | Romanian Revolution (Ceaușescu fall), US invasion of Panama (Operation Just Cause), Starrcade Future Shock |
| 1990-01 | Done | 5 | 2 | *Golden Axe* (Mega Drive) | Manuel Noriega surrender, Royal Rumble (Hogan/Warrior standoff), Burns' Day storm, Sinéad O'Connor #1 |
| 1990-02 | Done | 5 | 2 | *Dragon Quest IV* | Nelson Mandela released, Buster Douglas KOs Mike Tyson, Pale Blue Dot photo, Beats International #1 |
| 1990-03 | Done | 5 | 2 | *Turrican* (Rainbow Arts) | Poll Tax riots in Trafalgar Square, Lithuania declares independence, Namibia independence, Snap! The Power #1 |
| 1990-04 | Done | 5 | 2 | *Final Fantasy III* | WrestleMania VI (Ultimate Challenge), Hubble Space Telescope launch, Twin Peaks premiere, Madonna Vogue #1 |
| 1990-05 | Done | 5 | 2 | *Kick Off 2* | Yemeni unification, Boris Yeltsin elected, Capital Combat (RoboCop rescues Sting), Adamski & Seal Killer #1 |
| 1990-06 | Done | 5 | 2 | *Super Mario Bros. 3* (Western) | Italia '90 kickoff (Cameroon shocks Argentina), Total Recall, New Order World in Motion #1, Elton John #1 |
| 1990-07 | Done | 6 | 2 | *Metal Gear 2: Solid Snake* (MSX2) | Italia '90 semi-final (Gazza's tears), Three Tenors debut, Great American Bash (Sting wins title), Roger Waters Wall in Berlin |
| 1990-08 | Done | 6 | 2 | *Dr. Mario* (NES/GB) | Iraqi invasion of Kuwait, UN sanctions (Res 661), Operation Desert Shield, Turtle Power #1, SummerSlam steel cage |
| 1990-09 | Done | 5 | 2 | *Wing Commander* (PC DOS) | Fresh Prince of Bel-Air premiere, Two Plus Four Agreement (German treaty), Goodfellas release, The Joker #1 |
| 1990-10 | Done | 5 | 2 | *The Secret of Monkey Island* | Official German Reunification, Ghost UK release, Mikhail Gorbachev Nobel Peace Prize, Show Me Heaven #1 |
| 1990-11 | Done | 6 | 2 | *Super Mario World* (SFC) | Super Famicom launch in Japan, Margaret Thatcher resigns after 11 years, Undertaker debut at Survivor Series |
| 1990-12 | Done | 6 | 2 | *Commander Keen: Vorticons* | Channel Tunnel breakthrough under seabed, Home Alone UK release, Lech Wałęsa wins presidency, Tim Berners-Lee 1st WWW site |
| 1991-03 | Pilot | 8 | 4 | *Street Fighter II* | WrestleMania VII, Poll Tax scrapped, Birmingham Six, Clash #1 |
| 1996-10 | Pilot | 8 | 4 | *Tomb Raider* | Buried Alive, Two Fat Ladies, Cullen Report, Newcastle 5-0, Spice Girls |
| 1996-11 | Sample | 4 | 4 | *Command & Conquer: Red Alert* | Original C&VG November 1996 sample |
| 1998-01 | Done | 8 | 4 | *Resident Evil 2* | Lunar Prospector, Royal Rumble, Titanic UK, Oasis longest #1, Clinton denial |
| 1998-02 | Done | 7 | 3 | *Xenogears* | Nagano Olympics, Chumbawamba/Prescott, No Way Out, Celine Dion #1 |
| 1998-03 | Done | 6 | 4 | *StarCraft* | WrestleMania XIV, Titanic Oscars, Run-DMC vs Jason Nevins |
| 1998-04 | Done | 5 | 3 | *Unreal* | Good Friday Agreement, George Michael arrest, Pol Pot death, Inferno Match |
| 1998-05 | Done | 7 | 3 | *Gran Turismo* | Arsenal title, Sinatra death, Seinfeld finale, Over the Edge |
| 1998-06 | Done | 6 | 4 | *Banjo-Kazooie* | Beckham red card, Hell in a Cell (Mankind), Windows 98, B*Witched |
| 1998-07 | Done | 6 | 3 | *F-Zero X* | France World Cup, Saving Private Ryan, Festina scandal, Billie Piper record |
| 1998-08 | Done | 6 | 3 | *Tenchu: Stealth Assassins* | Omagh bombing, iMac G3, Clinton grand jury, Lock Stock, SummerSlam |
| 1998-09 | Done | 6 | 3 | *Metal Gear Solid* | Google incorporated, Millionaire debut, McGwire 62nd HR, Breakdown |
| 1998-10 | Done | 6 | 3 | *Fallout 2* | Pinochet arrest, Judgment Day, Game Boy Color, John Glenn, Cher Believe |
| 1998-11 | Done | 5 | 3 | *Half-Life* | Survivor Series Deadly Game, ISS Zarya launch |
| 1998-12 | Done | 6 | 3 | *The Legend of Zelda: Ocarina of Time* | Rock Bottom, Desert Fox, Clinton impeached, Spice Girls Goodbye #1 |
