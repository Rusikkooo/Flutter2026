# Hotel Booking — Lab 1

A hotel booking app for the Mobile Development course. Each stay is a room
offer with a check-in date, a room type and a limited number of rooms;
guests book a room under their profile name. All data lives in memory.

- **Item:** Stay — title, room type, check-in, rooms, guests, partner mode,
  optional description, favourite
- **Mode:** a partner listing turns the place into a link (must contain ://)
- **Tabs:** Stays · Favourites · Profile, plus a drawer with About and Reset data

## Decisions

The list of stays and the profile live in the State of Shell; tabs receive
them through constructors and send changes up as callbacks, so every tab
always shows the same data. The detail screen receives the stay and Shell's
callbacks through DetailArgs, because it never owns data: Book, Cancel and
Delete ask Shell to change the list, and the detail only refreshes its own
copy. The form returns a Stay through pop instead of writing to the list, so
the caller decides where it goes, and backing out returns null and changes
nothing. The grid is chosen by LayoutBuilder because it measures the space
the list actually gets, not the whole screen as MediaQuery would. PopScope
compares a record of the current field values with the record taken when the
form opened, so only a changed form asks "Discard changes?". With week 9's
tools I would store stays and the profile on the device so they survive a
restart, and move shared state out of Shell into a state-management layer.