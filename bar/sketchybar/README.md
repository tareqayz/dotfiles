# SketchyBar Configuration

Combined from the 10 pages in the [SketchyBar Configuration documentation](https://felixkratz.github.io/SketchyBar/config/bar), in their original navigation order.

Source: [FelixKratz/SketchyBar documentation](https://github.com/FelixKratz/SketchyBar/tree/6ed777608bc981937a929126abe4d5fffcf74c52/docs/config), commit `6ed777608bc981937a929126abe4d5fffcf74c52`. Retrieved September 24, 2026.

The original wording, tables, and code examples are preserved. Compilation changes are limited to removing site metadata and the color-picker import, adjusting heading levels and links, and adding navigation and source attribution. The interactive color picker is represented by a link to the live tool. Images remain linked to their original online locations.

Original documentation by the SketchyBar contributors. Distributed under the repository's GNU General Public License, version 3; the complete original license is reproduced at the end of this document.

## CLI Tool

Info on the `sketchybar` CLI tool

```bash
Usage: sketchybar [options]

Startup:
  -c, --config CONFIGFILE       Read CONFIGFILE as the configuration file
                                Default CONFIGFILE is ~/.config/sketchybar/sketchybarrc

Set global bar properties, see https://felixkratz.github.io/SketchyBar/config/bar
      --bar <setting>=<value> ... <setting>=<value>

Items and their properties, see https://felixkratz.github.io/SketchyBar/config/items
      --add item <name> <position>      Add item to bar
      --set <name> <property>=<value> ... <property>=<value>
                                        Change item properties
      --default <property>=<value> ... <property>=<value>
                                        Change default properties for new items
      --set <name> popup.<popup_property>=<value>
                                        Configure item popup menu
                                        See https://felixkratz.github.io/SketchyBar/config/popups
      --reorder <name> ... <name>       Reorder items
      --move <name> before <reference name>
      --move <name> after <reference name>
                                        Move item relative to reference item
      --clone <parent name> <name> [optional: before/after]
                                        Clone parent to create new item
      --rename <old name> <new name>    Rename item
      --remove <name>                   Remove item

Special components, see https://felixkratz.github.io/SketchyBar/config/components
      --add graph <name> <position> <width in points>
                                        Add graph component
      --push <name> <data point> ... <data point>
                                        Push data points to a graph
      --add space <name> <position>     Add space component
      --add bracket <name> <member name> ... <member name>
                                        Add bracket component
      --add alias <application_name> <position>
                                        Add alias component
      --add slider <name> <position> <width>
                                        Add slider component

Events and Scripting, see https://felixkratz.github.io/SketchyBar/config/events
      --subscribe <name> <event> ... <event>
                                        Subscribe to events
      --add event <name> [optional: <NSDistributedNotificationName>]
                                        Create custom event
      --trigger <event> [optional: <envvar>=<value> ... <envvar>=<value>]
                                        Trigger custom event

Querying information, see https://felixkratz.github.io/SketchyBar/config/querying
      --query bar                       Query bar properties
      --query <name>                    Query item properties
      --query defaults                  Query default properties
      --query events                    Query events
      --query default_menu_items        Query names of available items for aliases

Animations, see https://felixkratz.github.io/SketchyBar/config/animations
      --animate <linear|quadratic|tanh|sin|exp|circ> <duration> \
                --bar <property=value> ... <property=value>\
                --set <name> <property=value> ... <property=value>
                                Animate from given source to target property values

Reloading the config
      --hotload <boolean>               Enable or disable the config hotloader
      --reload [optional: <path>]       Reload the current or the given config
```

## Contents

1. [Bar Properties](#config-bar)
2. [Item Properties](#config-items)
3. [Special Components](#config-components)
4. [Popup Menus](#config-popups)
5. [Events & Scripting](#config-events)
6. [Querying Information](#config-querying)
7. [Animations](#config-animations)
8. [Type Nomenclature](#config-types)
9. [Reloading the configuration](#config-reloading)
10. [Tips & Tricks](#config-tricks)
11. [License](#license)

---

<a id="config-bar"></a>

## Bar Properties

Source: [Bar Properties](https://felixkratz.github.io/SketchyBar/config/bar)

### Configuration of the bar
For an example configuration see the supplied default *sketchybarrc*.
The configuration file resides in `~/.config/sketchybar/sketchybarrc` and is a
regular script that gets executed when *SketchyBar* launches, everything
persistent should be set up in this script.

It is possible to play with properties in the commandline and change
them on the fly while the bar is running, once you find a fitting
value you can include it in the `sketchybarrc` file, such that the configuration
is restored on restart. When configuring *SketchyBar* it can be helpful to stop
the brew service and run `sketchybar` from the commandline directly to see all
relevant error messages and warnings directly.

The global bar properties can be configured by invoking:
```bash
sketchybar --bar <setting>=<value> ... <setting>=<value>
```

where possible settings are:

| <setting\>       | <value\>                                 | default      | description                                                                                                                       |
| :-------:        | :------:                                 | :-------:    | -----------                                                                                                                       |
| `color`          | `<argb_hex>`                             | `0x44000000` | Color of the bar                                                                                                                  |
| `border_color`   | `<argb_hex>`                             | `0xffff0000` | Color of the bars border                                                                                                          |
| `position`       | `top`, `bottom`                          | `top`        | Position of the bar on the screen                                                                                                 |
| `height`         | `<integer>`                              | `25`         | Height of the bar                                                                                                                 |
| `notch_display_height`         | `<integer>`                              | `0`         | Override of the height of the bar on notched displays                                                                                                                 |
| `margin`         | `<integer>`                              | `0`          | Margin around the bar                                                                                                             |
| `y_offset`       | `<integer>`                              | `0`          | Vertical offset of the bar from its default position                                                                              |
| `corner_radius`  | `<positive_integer>`                     | `0`          | Corner radius of the bar                                                                                                          |
| `border_width`   | `<positive_integer>`                     | `0`          | Border width of the bars border                                                                                                   |
| `blur_radius`    | `<positive_integer>`                     | `0`          | Blur radius applied to the background of the bar                                                                                  |
| `padding_left`   | `<positive_integer>`                     | `0`          | Padding between the left bar border and the leftmost item                                                                         |
| `padding_right`  | `<positive_integer>`                     | `0`          | Padding between the right bar border and the rightmost item                                                                       |
| `notch_width`    | `<positive_integer>`                     | `200`        | The width of the notch to be accounted for on the internal display                                                                |
| `notch_offset`   | `<positive_integer>`                     | `0`          | Additional `y_offset` exclusively applied to notched screens                                                                      |
| `display`        | `main`, `all`, `<positive_integer list>` | `all`        | Display to show the bar on                                                                                                        |
| `hidden`         | `<boolean>`, `current`                   | `off`        | If all / the current bar is hidden                                                                                                |
| `topmost`        | `<boolean>`, `window`                    | `off`        | If the bar should be drawn on top of `everything`, or on top of all `window`s                                                     |
| `sticky`         | `<boolean>`                              | `on`         | Makes the bar sticky during space changes |
| `font_smoothing` | `<boolean>`                              | `off`        | If fonts should be smoothened                                                                                                     |
| `shadow`         | `<boolean>`                              | `off`        | If the bar should draw a shadow                                                                                                   |

You can find the nomenclature for all the types [here](#config-types).
If you are looking for colors, check out the [color picker](#color-picker).

---

<a id="config-items"></a>

## Item Properties

Source: [Item Properties](https://felixkratz.github.io/SketchyBar/config/items)

### Items and their properties
Items are the main building blocks of *SketchyBar* and can be configured in a number of ways. Items have the following basic structure:

![Item Structure](https://felixkratz.github.io/SketchyBar/img/bar_item.jpg)

#### Adding items to SketchyBar
```bash
sketchybar --add item <name> <position>
```
where the `<name>` should not contain whitespaces (or must be quoted), it is later used to refer to this item in the configuration.
The `<position>` is the placement in the bar and can be either `left`, `right`, `center` or `q` (which is left of the notch) and `e` (which is right of the notch).
The items will appear in the bar in the order in which they are added, but can be moved later on.

| `<name>`     | `<string>`                                                                                        |
| -----        | ---------                                                                                         |
| `<position>` | `left`, `right`, `center`, (`q`, `e` [#120](https://github.com/FelixKratz/SketchyBar/issues/120)) |

#### Changing item properties
```bash
sketchybar --set <name> <property>=<value> ... <property>=<value>
```
where the `<name>` is used to target the item.
(The `<name>` can be a regular expression inside of two slashed: `/<regex>/`)

A list of properties available to the *set* command is listed below (components might have additional properties, see the respective component section for them):

#### Geometry Properties

| <property\>                        | <value\>                            | default   | description                                           |
| : -------:                         | :------:                            | :-------: | -----------                                           |
| `drawing`                          | `<boolean>`                         | `on`      | If the item should be drawn into the bar              |
| `position`                         | `left`, `right`, `center`           |           | Position of the item in the bar                       |
| `space`                            | `<positive_integer list>`           | `0`       | Spaces to show this item on                           |
| `display`                          | `<positive_integer list>`, `active` | `0`       | Displays to show this item on                         |
| `ignore_association`               | `<boolean>`                         | `off`     | Ignores all space / display associations while on     |
| `y_offset`                         | `<integer>`                         | `0`       | Vertical offset applied to the item                   |
| `padding_left`                     | `<integer>`                         | `0`       | The padding applied left of the item                  |
| `padding_right`                    | `<integer>`                         | `0`       | The padding applied right of the item                 |
| `width`                            | `<positive_integer>` or `dynamic`   | `dynamic` | Makes the *item* use a fixed *width* given in points  |
| `scroll_texts`                     | `<boolean>`       | `off`           | Controls the automatic scroll of all items texts, which are truncated by the `max_chars` property  |
| `blur_radius`                      | `<positive_integer>`                | `0`       | The blur radius applied to the background of the item |
| `background.<background_property>` |                                     |           | Items support all `background` properties             |

#### Icon properties

| <property\>            | <value\>   | default   | description                         |
| :-------:              | :------:   | :-------: | -----------                         |
| `icon`                 | `<string>` |           | Icon of the item                    |
| `icon.<text_property>` |            |           | Icons support all *text* properties |

#### Label properties

| <property\>             | <value\>   | default   | description                          |
| :-------:               | :------:   | :-------: | -----------                          |
| `label`                 | `<string>` |           | Label of the item                    |
| `label.<text_property>` |            |           | Labels support all *text* properties |

#### Scripting properties

| <property\>    | <value\>                  | default   | description                                                                                                                            |
| :-------:      | :------:                  | :-------: | -----------                                                                                                                            |
| `script`       | `<path>`, `<string>`      |           | Script to run on an `event`                                                                                                            |
| `click_script` | `<path>`, `<string>`      |           | Script to run on a mouse click (Difference to `mouse.clicked` event: [#109](https://github.com/FelixKratz/SketchyBar/discussions/109)) |
| `update_freq`  | `<positive_integer>`      | `0`       | Time in seconds between routine script executions (`0` means never)                                                                    |
| `updates`      | `<boolean>`, `when_shown` | `on`      | If and when the item updates e.g. via script execution                                                                                 |
| `mach_helper`  | `<string>`                |           | Registers a helper for direct event notifications ([example](https://github.com/FelixKratz/SketchyBarHelper))                          |

#### Text properties

| <text_property\>                   | <value\>                          | default                    | description                                                                                  |
| :-------:                          | :------:                          | :-------:                  | -----------                                                                                  |
| `drawing`                          | `<boolean>`                       | `on`                       | If the text is rendered                                                                      |
| `highlight`                        | `<boolean>`                       | `off`                      | If the text uses the `highlight_color` or the regular `color`                                |
| `color`                            | `<argb_hex>`                      | `0xffffffff`               | Color used to render the text                                                                |
| `highlight_color`                  | `<argb_hex>`                      | `0xff000000`               | Highlight color of the text (e.g. for active space icon                                      |
| `padding_left`                     | `<integer>`                       | `0`                        | Padding to the left of the `text`                                                            |
| `padding_right`                    | `<integer>`                       | `0`                        | Padding to the right of the `text`                                                           |
| `y_offset`                         | `<integer>`                       | `0`                        | Vertical offset applied to the `text`                                                        |
| `font`                             | `<family>:<type>:<size>`          | `Hack Nerd Font:Bold:14.0` | The font to be used for the `text`                                                           |
| `font.family`                      | `<string>`                        | `Hack Nerd Font`           | The font family to be used for the `text`                                                    |
| `font.style`                       | `<string>`                        | `Bold`                     | The font style to be used for the `text`                                                     |
| `font.size`                        | `<float>`                         | `14.0`                     | The font size to be used for the `text`                                                      |
| `string`                           | `<string>`                        |                            | Sets the text to the specified string                                                        |
| `scroll_duration`                        | `<positive_integer>`              | `100`                        | Sets the scroll speed of text trucated by `max_chars` on items with `scroll_texts` enabled |
| `max_chars`                        | `<positive_integer>`              | `0`                        | Sets the maximum characters to display (can be scrolled via the items `scroll_texts` property) |
| `width`                            | `<positive_integer>` or `dynamic` | `dynamic`                  | Makes the `text` use a fixed `width` given in points                                         |
| `align`                            | `center`, `left`, `right`         | `left`                     | Aligns the `text` in its container when it has a fixed `width` larger than the content width |
| `background.<background_property>` |                                   |                            | Texts support all `background` properties                                                    |
| `shadow.<shadow_property>`         |                                   |                            | Texts support all `shadow` properties                                                        |

#### Background properties

| <background_property\>     | <value\>                    | default      | description                                                                    |
| :-------:                  | :------:                    | :-------:    | -----------                                                                    |
| `drawing`                  | `<boolean>`                 | `off`        | If the `background` should be rendered                                         |
| `color`                    | `<argb_hex>`                | `0x00000000` | Fill color of the `background`                                                 |
| `border_color`             | `<argb_hex>`                | `0x00000000` | Color of the backgrounds border                                                |
| `border_width`             | `<positive_integer>`        | `0`          | Width of the background border                                                 |
| `height`                   | `<positive_integer>`        | `0`          | Overrides the `height` of the background                                       |
| `corner_radius`            | `<positive_integer>`        | `0`          | Corner radius of the background                                                |
| `padding_left`             | `<integer>`                 | `0`          | Padding to the left of the `background`                                        |
| `padding_right`            | `<integer>`                 | `0`          | Padding to the right of the `background`                                       |
| `y_offset`                 | `<integer>`                 | `0`          | Vertical offset applied to the `background`                                    |
| `x_offset`                 | `<integer>`                 | `0`          | Horizontal offset applied to the `background`                                    |
| `clip`                     | `<float>`                   | `0.0`        | By how much the background clips the bar (i.e. transparent holes in the bar)   |
| `image`                    | `<path>`, `app.<bundle-id>`, `app.<name>`, `media.artwork` |              | The image to display in the bar                   |
| `image.<image_property>`   |                             |              | Backgrounds support all `image` properties                                     |
| `shadow.<shadow_property>` |                             |              | Backgrounds support all `shadow` properties                                    |

#### Image properties

| <image_property\> | <value\>    | default   | description                                          |
| :-------:         | :------:    | :-------: | -----------                                          |
| `drawing`         | `<boolean>` | `off`     | If the image should draw                             |
| `scale`           | `<float>`   | `1.0`     | The scale factor that should be applied to the image |
| `border_color`             | `<argb_hex>`                | `0x00000000` | Color of the image border |
| `border_width`             | `<positive_integer>`        | `0`          | Width of the image border |
| `corner_radius`            | `<positive_integer>`        | `0`          | Corner radius of the image |
| `padding_left`             | `<integer>`                 | `0`          | Padding to the left of the image |
| `padding_right`            | `<integer>`                 | `0`          | Padding to the right of the image  |
| `y_offset`                 | `<integer>`                 | `0`          | Vertical offset applied to the image |
| `string`                    | `<path>`, `app.<bundle-id>`, `app.<name>`, `media.artwork` |              | The image to display in the bar                   |
| `shadow.<shadow_property>` |                             |              | Images support all `shadow` properties |

#### Shadow properties

| <shadow_property\>  | <value\>             | default      | description                   |
| :-------:           | :------:             | :-------:    | -----------                   |
| `drawing`           | `<boolean>`          | `off`        | If the shadow should be drawn |
| `color`             | `<argb_hex>`         | `0xff000000` | Color of the shadow           |
| `angle`             | `<positive_integer>` | `30`         | Angle of the shadow           |
| `distance`          | `<positive_integer>` | `5`          | Distance of the shadow        |

#### Changing the default values for all further items
It is possible to change the *defaults* at every point in the configuration. All item created *after* changing the defaults will
inherit these properties from the default item.

```bash
sketchybar --default <property>=<value> ... <property>=<value>
```
this works for all item properties.

#### Item Reordering
It is possible to reorder items by invoking
```bash 
sketchybar --reorder <name> ... <name>
```
where a new order can be supplied for arbitrary items. Only the specified items get reordered, by swapping them around, everything else stays the same. E.g. if you want to swap two items 
simply call
```bash 
sketchybar --reorder <item 1> <item 2>
```
#### Moving Items to specific positions
It is possible to move items and order them next to a reference item.

Move Item `<name>` to appear *before* item `<reference name>`:
```bash 
sketchybar --move <name> before <reference name>
```
Move Item `<name>` to appear *after* item `<reference name>`:
```bash 
sketchybar --move <name> after <reference name>
```
#### Item Cloning
It is possible to clone another item instead of adding a completely blank item
```bash 
sketchybar --clone <parent name> <name> [optional: before/after]
```
the new item will inherit *all* properties of the parent item. The optional *before* and *after* modifiers can be used
to move the item *before*, or *after* the parent, equivalently to a --move command.
#### Renaming Items
It is possible to rename any item. The new name should obviously not be in use by another item:
```bash 
sketchybar --rename <old name> <new name>
```
#### Removing Items
It is possible to remove any item by invoking, the item will be completely destroyed and removed from brackets 
```bash 
sketchybar --remove <name>
```
the `<name>` can again be a regex: `/<regex>/`.

---

<a id="config-components"></a>

## Special Components

Source: [Special Components](https://felixkratz.github.io/SketchyBar/config/components)

### Components -- Special Items with special properties
Components are essentially items, but with special properties.
Currently there are the components (more details in the corresponding sections below):
* *graph*: showing a graph,
* *space*: representing a mission control space
* *bracket*: brackets together other items
* *alias*: an alias of a menu bar item from the macOS bar
* *slider*: a slider that shows a progression and can be clicked/dragged to set a new value

#### Data Graph -- Draws an arbitrary graph into the bar
```bash
sketchybar --add graph <name> <position> <width in points>
```

Additional graph properties:

| <property\>        | <value\>     | default      | description                 |
| :-------:          | :------:     | :-------:    | -----------                 |
| `graph.color`      | `<argb_hex>` | `0xffcccccc` | Color of the graph line     |
| `graph.fill_color` | `<argb_hex>` | `0xffcccccc` | Fill color of the graph     |
| `graph.line_width` | `<float>`    | `0.5`        | Width of the line in points |

Push data points into the graph via:
```bash
sketchybar --push <name> <data point> ... <data point>
```
where the `<data point>` is a floating point number between 0 and 1.

Graphs usually take the entire height of the bar as a drawing canvas, however,
if you set a background for the graph item and set a height for it, the graph
will draw inside of the background. With a background enabled, the graph can
also be moved via a `y_offset`, e.g.:
```bash
sketchybar --set <graph name> background.color=0xff00ff00 background.height=20 y_offset=2
```

#### Space -- Associate mission control spaces with an item
```bash
sketchybar --add space <name> <position>
```
The space component overrides the definition of the following properties:
* *space*: Which space this item represents
* (optional) *display*: On which display the *space* is shown.
The `space` property must be set to properly associate this item with the corresponding mission control space.
Optionally, you can provide an `display` to force a space item to stay on a specific display, otherwise the
item will draw on the screen on which the space is currently located. 

The space component has additional variables available in *scripts*:
```bash
$SELECTED
$SID
$DID
```
where `$SELECTED` has the value `true` if the associated space is selected and
`false` if the associated space is not selected, while
`$SID` holds the space id and `$DID` the display id.

By default the space component invokes the following script:
```bash
sketchybar --set $NAME icon.highlight=$SELECTED
```
which you can freely configure to your liking by supplying a different script
to the space component:
```bash
sketchybar --set <name> script=<script/path>
```

For performance reasons the space script is only run on a change in the
`$SELECTED` variable, i.e. if the associated space has become active
or has resigned being active.

#### Item Bracket -- Group Items in e.g. colored sections
It is possible to create a common background for any number of items, i.e. to bracket together items, via the command:
```bash
sketchybar --add bracket <name> <member name> ... <member name>
```
The `<member name>` is a name of any item in the bar that should be added to the bracket.
The `<member name>` can also be a `/<regex>/` expression.
It is now possible to set properties for the bracket, just as for any item or component. Brackets currently only support all background features.
E.g., if I wanted a colored background around my space components (which are named *space.1*, *space.2*, *space.3*) I would set it up like this:
```bash
sketchybar --add bracket spaces space.1 space.2 space.3     \
           --set         spaces background.color=0xffffffff \
                                background.corner_radius=4  \
                                background.height=20
```
Alternatively, if I had a number of spaces, called *space.1*, *space.2*, etc. the regex syntax comes in handy:
```bash
sketchybar --add bracket spaces '/space\..*/'               \
           --set         spaces background.color=0xffffffff \
                                background.corner_radius=4  \
                                background.height=20
```
this draws a white background below all my space components.

Brackets are very flexible with their members, i.e. it is no problem to bracket together a `left` and a `center` item,
the background will span all the way between those items.

#### Item Alias -- Mirror items of the original macOS status bar into sketchybar
It is possible to create an alias for default menu bar items
(such as MeetingBar, etc.) in sketchybar. The default menu bar can be set to
autohide and this should still work.

To create an alias of a default menu bar item use the following syntax:
```bash
sketchybar --add alias <application_name> <position>
```
this operation requires *screen capture permissions*, which should be granted
in the system preferences.

This will put the default macOS menu bar item into sketchybar. If an
application has multiple menu bar widgets the command can be overloaded by
providing a *window_owner* and a *window_name*
```bash
sketchybar --add alias "<window_owner>,<window_name>" <position>
```
this way the default system items can also be aliased in sketchybar as well,
e.g.:
- "Control Center,Bluetooth"
- "Control Center,WiFi"
- ...

Or the individual widgets of [Stats](https://github.com/exelban/stats):
- "Stats,CPU_Mini"
- etc...

All further macOS menu bar items currently available on your system can be
found via the command
```bash
sketchybar --query default_menu_items
```
where all items with their respective owner and name are listed.

You can override the color of an alias via the property:
```bash
sketchybar --set <name> alias.color=<argb_hex>
```
and change its scale via:
```bash
sketchybar --set <name> alias.scale=<float>
```

By default, an alias will update once a second, the update interval can be
adapted via:
```bash
sketchybar --set <name> alias.update_freq=<positive_integer>
```

#### Slider -- A draggable progression indicator
A slider can be added to the bar via the command:
```bash
sketchybar --add slider <name> <position> <width>
```
Like all components, the slider only adds some additional properties and
functionality to a regular item. Thus all properties of regular items are
available for the slider. Additionally the slider exposes the additional
properties:

| <property\>                               | <value\>             | default      | description                                         |
| :-------:                                 | :------:             | :-------:    | -----------                                         |
| `slider.width`                            | `<positive_integer>` | `100`        | Total width of the slider in points                 |
| `slider.percentage`                       | `<positive_integer>` | `0`          | Progression of the slider in percent (0-100)        |
| `slider.highlight_color`                  | `<argb_hex>`         | `0xff0000ff` | Color that highlights the progression of the slider |
| `slider.knob`                             | `<string>`           |              | Knob of the slider                                  |
| `slider.knob.<text_property>`             |                      |              | The slider knob supports all `text` properties      |
| `slider.background.<background_property>` |                      |              | The slider supports all `background` properties     |

The slider can be enabled to receive `mouse.clicked` events by subscribing to this event.
A slider will receive the additional environment variable `$PERCENTAGE` on a click in its
script, which represents the percentage corresponding to the click location.
If a slider is dragged by the mouse it will only send a single event on drag release and
track the mouse during the drag.

---

<a id="config-popups"></a>

## Popup Menus

Source: [Popup Menus](https://felixkratz.github.io/SketchyBar/config/popups)

### Popup Menus
![Simple Popup](https://user-images.githubusercontent.com/22680421/146688291-b8bc5e77-e6a2-42ee-bd9f-b3709c63d936.png)

Popup menus are a powerful way to make further `items` accessible in a small popup window below any bar item.
Every item has a popup available with the properties:

```bash
sketchybar --set <name> popup.<popup_property>=<value>
```

| <popup_property\>                  | <value\>                  | default    | description                                                  |
| :-------:                          | :------:                  | :-------:  | -----------                                                  |
| `drawing`                          | `<boolean>`               | `off`      | If the `popup` should be rendered                            |
| `horizontal`                       | `<boolean>`               | `off`      | If the `popup` should render horizontally                    |
| `topmost`                          | `<boolean>`               | `on`       | If the `popup` should always be on top of all other windows  |
| `height`                           | `<positive_integer>`      | bar height | The vertical spacing between items in a popup                |
| `blur_radius`                      | `<positive_integer>`      | `0`        | The blur applied to the popup background                     |
| `y_offset`                         | `<integer>`               | `0`        | Vertical offset applied to the `popup`                       |
| `align`                            | `left`, `right`, `center` | `left`     | Alignment of the popup with its parent item in the bar       |
| `background.<background_property>` |                           |            | Popups have a background and support all properties          |

Items can be added to a popup menu by setting the `position` of those items to `popup.<name>` where `<name>` is the name of the item containing the popup.
You can find a demo implementation of this [here](https://github.com/FelixKratz/SketchyBar/discussions/12?sort=new#discussioncomment-1843975).

---

<a id="config-events"></a>

## Events & Scripting

Source: [Events & Scripting](https://felixkratz.github.io/SketchyBar/config/events)

### Events and Scripting
All items can *subscribe* to arbitrary *events*; when the *event* happens,
all items subscribed to the *event* will execute their *script*.
This can be used to create more reactive and performant items which react to
events rather than polling for a change.
```bash
sketchybar --subscribe <name> <event> ... <event>
```
where the events are:

| <event\>               | description                                                                                         | `$INFO`                                |
| :-------:              | :------:                                                                                            | :------:                               |
| `front_app_switched`   | When the front application changes (not triggered if a different window of the same app is focused) | front application name                 |
| `space_change`         | When the active mission control space changes                                                       | JSON for active spaces on all displays |
| `space_windows_change` | When a window is created or destroyed on a space                                                    | JSON containing the space and all app windows on this space |
| `display_change`       | When the active display is changed                                                                  | new active display id                  |
| `volume_change`        | When the system audio volume is changed                                                             | new volume in percent                  |
| `brightness_change`    | When a displays brightness is changed                                                               | new brightness in percent              |
| `power_source_change`  | When the devices power source is changed                                                            | new power source (`AC` or `BATTERY`)   |
| `wifi_change`          | When the device connects of disconnects from wifi                                                   | new WiFi SSID or empty on disconnect (not working since macOS Sonoma) |
| `media_change`         | When a change in now playing media is performed (deprecated on macOS 26.0)                                      | media info in a JSON structure         |
| `system_will_sleep`    | When the system prepares to sleep                                                                   |                                        |
| `system_woke`          | When the system has awaken from sleep                                                               |                                        |
| `mouse.entered`        | When the mouse enters over an item                                                                  |                                        |
| `mouse.exited`         | When the mouse leaves an item                                                                       |                                        |
| `mouse.entered.global` | When the mouse enters over *any* part of the bar                                                    |                                        |
| `mouse.exited.global`  | When the mouse leaves *all* parts of the bar                                                        |                                        |
| `mouse.clicked`        | When an item is clicked                                                                             | mouse button and modifier info         |
| `mouse.scrolled`       | When the mouse is scrolled over an item                                                             | scroll wheel delta                     |
| `mouse.scrolled.global`| When the mouse is scrolled over an empty region of the bar                                          | scroll wheel delta                     |

Some events send additional information in the `$INFO` variable
When an item is subscribed to these events the *script* is run and it gets passed the `$SENDER` variable, which holds exactly the above names to distinguish between the different events.
It is thus possible to have a script that reacts to each event differently e.g. via a switch for the `$SENDER` variable in the *script*.

Alternatively a fixed *update_freq* can be *--set*, such that the event is routinely run to poll for change, the `$SENDER` variable will in this case hold the value `routine`.

When an item invokes a script, the script has access to some environment variables, such as:
```bash
$NAME
$SENDER
$CONFIG_DIR
```
Where `$NAME` is the name of the item that has invoked the script and `$SENDER` is the reason why the script is executed.
The variable `$CONFIG_DIR` contains the absolute path of the directory where the current sketchybarrc file is located.

If an item is *clicked* the script has access to the additional variables:
```bash 
$BUTTON
$MODIFIER
```
where the `$BUTTON` can be *left*, *right* or *other* and specifies the mouse button that was used to click the item, while the `$MODIFIER` is either *shift*, *ctrl*, *alt* or *cmd* and 
specifies the modifier key held down while clicking the item.

If an item receive a *scroll* event from the mouse the script gets send the additional `$SCROLL_DELTA` variable.

All scripts are forced to terminate after 60 seconds and do not run while the system is sleeping. 

#### Creating custom events
This allows to define events which are triggered by arbitrary applications or manually (see Trigger custom events).
Items can also subscribe to these events for their script execution.
```bash
sketchybar --add event <name> [optional: <NSDistributedNotificationName>]
```
Optional: You can subscribe to the notifications sent to the NSDistributedNotificationCenter e.g.
the notification Spotify sends on track change:
`com.spotify.client.PlaybackStateChanged` ([example](https://github.com/FelixKratz/SketchyBar/discussions/12#discussioncomment-1455842)), or the
notification sent by the system when the screen is unlocked:
`com.apple.screenIsUnlocked` ([example](https://github.com/FelixKratz/SketchyBar/discussions/12?sort=new#discussioncomment-2979651))
to create more responsive items.
Custom events that subscribe to NSDistributedNotificationCenter notifications
will receive additional notification information in the `$INFO` variable if available.
For more NSDistributedNotifications see [this discussion](https://github.com/FelixKratz/SketchyBar/discussions/151).

#### Triggering custom events
This triggers a custom event that has been added before
```bash
sketchybar --trigger <event> [Optional: <envvar>=<value> ... <envvar>=<value>]
```
Optionally you can add environment variables to the trigger command witch are passed to the script, e.g.:
```bash
sketchybar --trigger demo VAR=Test
```
will trigger the demo event and `$VAR` will be available as an environment variable in the scripts that this event invokes.

#### Forcing all shell scripts to run and the bar to refresh
This command forces all scripts to run and all events to be emitted, it should
*never* be used in an item script, as this would lead to infinite loops. It
is prominently needed after the initial configuration to properly initialize
all items by forcing all their scripts to run
```bash
sketchybar --update
```

---

<a id="config-querying"></a>

## Querying Information

Source: [Querying Information](https://felixkratz.github.io/SketchyBar/config/querying)

### Querying
*SketchyBar* can be queried for information about a number of things.
#### Bar Properties
Information about the bar can be queried via:
```bash
sketchybar --query bar
```
The output is a JSON structure containing relevant information about the configuration settings of the bar.
#### Item Properties
Information about an item can be queried via:
```bash
sketchybar --query <name>
```
The output is a JSON structure containing relevant information about the configuration of the item.
#### Default Properties
Information about the current defaults.
```bash
sketchybar --query defaults
```
#### Event Properties
Information about the events.
```bash
sketchybar --query events
```

#### macOS Menu Bar Item Names (for use with aliases)
The names of the menu bar items in the default macOS bar:
```bash
sketchybar --query default_menu_items
```

#### Display Configuration Information
Information about the current display configuration:
```bash
sketchybar --query displays
```

---

<a id="config-animations"></a>

## Animations

Source: [Animations](https://felixkratz.github.io/SketchyBar/config/animations)

### Animating the bar
All transitions between `<argb_hex>`, `<integer>` and `<positive_integer>`
values can be animated, by prepending the animation command in front of any
regular `--set` or `--bar` command:

```bash
sketchybar --animate <curve> <duration> \
           --bar <property>=<value> ... <property>=<value> \
           --set <name> <property>=<value> ... <property>=<value>
```
where the `<curve>` is any of the animation curves:
- `linear`, `quadratic`, `tanh`, `sin`, `exp`, `circ`

The `<duration>` is a positive integer quantifying the number of animation
steps (the duration is the frame count on a 60Hz display, such that the
temporal duration of the animation in seconds is given by `<duration>` / 60).

The animation system *always* animates between all *current* values and the
values specified in a configuration command (i.e. `--bar` or `--set` commands).

#### Perform multiple animations chained together
If you want to chain two or more animations together, you can do so by simply
changing the property multiple times in a single call, e.g.
```bash
sketchybar --animate sin 30 --bar y_offset=10 y_offset=0
```
will animate the bar to the first offset and after that to the second offset.
You can chain together as main animations as you like and you can change the
animation function in between. This is a nice way to create custom animations
with key-frames. You can also make other properties wait with their animation
till another animation is finished, by simply setting the property that should
wait to its current value in the first animation.

A new non-animated `--set` command targeting a currently animated property will
cancel the animation queue and immediately set the value.

A new animated `--set` command targeting a currently animated property will
cancel the animation queue and immediately begin with the new animation,
beginning at the current state.

---

<a id="config-types"></a>

## Type Nomenclature

Source: [Type Nomenclature](https://felixkratz.github.io/SketchyBar/config/types)

### Type nomenclature

| `type`                    | `values`                                                         |
| -----                     | ---------                                                        |
| `<boolean>`               | `on`, `off`, `yes`, `no`, `true`, `false`, `1`, `0`, `toggle`    |
| `<argb_hex>`              | Color as an 8 digit hex with alpha, red, green and blue channels |
| `<path>`                  | An absolute file path                                            |
| `<string>`                | Any UTF-8 string or symbol                                       |
| `<float>`                 | A floating point number                                          |
| `<integer>`               | An integer                                                       |
| `<positive_integer>`      | A positive integer                                               |
| `<positive_integer list>` | A comma separated list of positive integers                      |

#### Further `<boolean>` operations
All `<boolean>` properties can be negated with an exclamation mark, e.g. `!on`.

#### Further `<argb_hex>` operations
All colors (i.e. all fields where the value type is `<argb_hex>`) can
additionally be accessed to change specific channels like this:

| <color_property\>  | <value\>     | default      | description                             |
| :-------:          | :------:     | :-------:    | -----------                             |
| `alpha`            | `<float>`    | `1.0`        | The alpha channel of the color (0 to 1) |
| `red`              | `<float>`    | `1.0`        | The red channel of the color (0 to 1)   |
| `green`            | `<float>`    | `1.0`        | The green channel of the color (0 to 1) |
| `blue`             | `<float>`    | `1.0`        | The blue channel of the color (0 to 1)  |

So for example, if I want to only change the alpha channel of the bars color I would use
```bash
sketchybar --bar color.alpha=0.5
```

---

<a id="config-reloading"></a>

## Reloading the configuration

Source: [Reloading the configuration](https://felixkratz.github.io/SketchyBar/config/reloading)

### Reloading the configuration file of the bar
If you wish to reload the configuration file of the bar without resorting to
manually restarting the process you can use the following command:

```bash
sketchybar --reload [Optional: <path>]
```
which, has the same effect as restarting the process, but is a bit more
convenient. Additionally, an optional `<path>` argument to a new `sketchybarrc`
file can be given to load a different configuration. If the optional argument
is left out, the current configuration is reloaded.

### Hotloading the configuration of the bar
If you wish that the bar automatically reloads the configuration file once you
edit it, you can use the hotload functionality included in SketchyBar. It will
monitor the directory of the current configuration for changes and reload the
configuration should it detect file changes. To control the hotload feature you
can use:
```bash
sketchybar --hotload <boolean>
```

---

<a id="config-tricks"></a>

## Tips & Tricks

Source: [Tips & Tricks](https://felixkratz.github.io/SketchyBar/config/tricks)

### Batching of configuration commands
It is possible to batch commands together into a single call to *SketchyBar*, this can be helpful to
keep the configuration file a bit cleaner and also to reduce startup times.
Assume 5 individual configuration calls to *SketchyBar*:
```bash
sketchybar --bar position=top
sketchybar --bar margin=5
sketchybar --add item demo left
sketchybar --set demo label=Hello
sketchybar --subscribe demo system_woke
```
after each configuration command the bar is redrawn (if needed), thus it is
faster to append these calls into a single command like so:
```bash
sketchybar --bar position=top           \
                 margin=5               \
           --add item demo left         \
           --set demo label=Hello       \
           --subscribe demo system_woke
```
The backslash at the end of the first 4 lines is the default bash way to join lines together and should not be followed by a whitespace.  

#### Using bash arrays for cleaner configuration
Lets assume this bar configuration command (from the default config):
```bash
sketchybar --bar height=32        \
                 blur_radius=30   \
                 position=top     \
                 sticky=off       \
                 padding_left=10  \
                 padding_right=10 \
                 color=0x15ffffff
```
We can rewrite this as a bash array to get rid of the backslashes and pass the
contents of the array to the `--bar` command:
```bash
bar=(
  height=32
  blur_radius=30
  position=top
  sticky=off
  padding_left=10
  padding_right=10
  color=0x15ffffff
)

sketchybar --bar "${bar[@]}"
```

### Debugging Problems
If you are experiencing problems with the configuration of *SketchyBar* it might be helpful to work through the following steps:
* 1.) Start `sketchybar` directly from the commandline to see the verbose error/warning messages
* 2.) Make sure you have no trailing whitespaces after the bash newline escape char `\`
* 3.) Make sure your scripts are made executable via: `chmod +x script.sh`
* 4.) Reduce the configuration to a minimal example and narrow down the problematic region
* 5.) Try running erroneous scripts directly in the commandline
* 6.) Query *SketchyBar* for relevant properties and use them to deduce the problems root cause
* 7.) Create an [Issue](https://github.com/FelixKratz/SketchyBar/issues) on GitHub, a second pair of eyes might now be the only thing that helps

<a id="color-picker"></a>

### Color Picker
SketchyBar uses the argb hex color format, which means: `0xAARRGGBB` encodes a
color.

[Open the interactive color picker](https://felixkratz.github.io/SketchyBar/config/tricks#color-picker).

### Finding Icons
The default font *SketchyBar* uses is the *Hack Nerd Font* which means all *Nerdfont* icons can be used.
Refer to the *Nerdfont* [cheat-sheet](https://www.nerdfonts.com/cheat-sheet) to find new icons.

Additionally, it is possible to use other icons and glyphs from different fonts,
such as the [sf-symbols](https://developer.apple.com/sf-symbols/) from apple.
Those symbols can be installed via brew:
```bash
brew install --cask sf-symbols
```
After installing this package, an app called `SF Symbols` will be available where you can find all the available icons.
Once you find a fitting icon, right click it, select *Copy Symbol* and paste it in the relevant configuration file.

If you are looking for stylised app icons you might want to checkout the excellent community maintained
[app-icon-font](https://github.com/kvndrsslr/sketchybar-app-font) for SketchyBar.

### Multiple Bars
It is possible to have multiple independent instances of SketchyBar running.
This is possible by changing the `argv[0]` of the sketchybar program. This is
very easy, e.g. by symlinking the sketchybar binary with a different name, e.g.
`bottom_bar`:
```bash
ln -s $(which sketchybar) $(dirname $(which sketchybar))/bottom_bar
```
This symlink can now be used to spawn and target an additional bar, i.e. for
this bar we do not call `sketchybar --bar color=0xffff0000`, but rather
`bottom_bar --bar color=0xffff0000` and start it by running `bottom_bar` in the
commandline.

The config path for this additional bar is in `$HOME/.config/bottom_bar/`.
Of course `bottom_bar` is only an example and can be freely replaced with any
other identifier. The name of the bar is available in the environment variable `$BAR_NAME` in all scripts, making it possible to create bar-agnostic scripts by replacing `sketchybar` with `$BAR_NAME`.

### Performance optimizations
*SketchyBar* can be configured to have a *very* small performance footprint. In the following I will highlight some optimizations that can be used to reduce the footprint further. 

* Batch together configuration commands where ever possible.
* Set *updates=when_shown* for items that do not need to run their script if they are not rendered.
* Reduce the *update_freq* of *scripts* and *aliases* and use event-driven scripting when ever possible.
* Do not add *aliases* to apps that are not always running, otherwise *SketchyBar* searches for them continuously.
* (Advanced; Only >=v2.9.0) Use compiled `mach_helper` programs that directly interface with *SketchyBar* [example](https://github.com/FelixKratz/SketchyBarHelper) for performance sensitive tasks

---