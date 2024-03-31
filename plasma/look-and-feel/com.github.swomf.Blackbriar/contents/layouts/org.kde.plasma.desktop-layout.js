// Based off of the example layouts of endeavouros and breeze
// /usr/share/plasma/look-and-feel/ ... /contents/layouts/org.kde.plasma.desktop-layout.js

var panel = new Panel
var panelScreen = panel.screen

panel.height = Math.floor(gridUnit * 2.25) // 40?
// "location": "bottom" probably not needed

// Restrict horizontal panel to a maximum size of a 21:9 monitor
const maximumAspectRatio = 21/9;
if (panel.formFactor === "horizontal") {
    const geo = screenGeometry(panelScreen);
    const maximumWidth = Math.ceil(geo.height * maximumAspectRatio);

    if (geo.width > maximumWidth) {
        panel.alignment = "center";
        panel.minimumLength = maximumWidth;
        panel.maximumLength = maximumWidth;
    }
}

// Start menu
var kickoff = panel.addWidget("org.kde.plasma.kickoff")
kickoff.currentConfigGroup = ["Shortcuts"]
kickoff.writeConfig("icon", "draw-circle") // from Papirus icons

// kickoff.writeConfig("global", "Alt+F1") // this didn't seem to do anything

// Virtual desktops menu (Maybe it's better on the right of the taskmanager?)
panel.addWidget("org.kde.plasma.pager")

// Task bar
let taskBar = panel.addWidget("org.kde.plasma.taskmanager") // as opposed to icontasks
taskBar.currentConfigGroup = ["General"]
taskBar.writeConfig("launchers",["preferred://browser"])
taskBar.writeConfig("separateLaunchers", "false")

panel.addWidget("org.kde.plasma.marginsseparator")

/* Next up is determining whether to add the Input Method Panel
 * widget to the panel or not. This is done based on whether
 * the system locale's language id is a member of the following
 * white list of languages which are known to pull in one of
 * our supported IME backends when chosen during installation
 * of common distributions. */

var langIds = ["as",    // Assamese
               "bn",    // Bengali
               "bo",    // Tibetan
               "brx",   // Bodo
               "doi",   // Dogri
               "gu",    // Gujarati
               "hi",    // Hindi
               "ja",    // Japanese
               "kn",    // Kannada
               "ko",    // Korean
               "kok",   // Konkani
               "ks",    // Kashmiri
               "lep",   // Lepcha
               "mai",   // Maithili
               "ml",    // Malayalam
               "mni",   // Manipuri
               "mr",    // Marathi
               "ne",    // Nepali
               "or",    // Odia
               "pa",    // Punjabi
               "sa",    // Sanskrit
               "sat",   // Santali
               "sd",    // Sindhi
               "si",    // Sinhala
               "ta",    // Tamil
               "te",    // Telugu
               "th",    // Thai
               "ur",    // Urdu
               "vi",    // Vietnamese
               "zh_CN", // Simplified Chinese
               "zh_TW"] // Traditional Chinese

if (langIds.indexOf(languageId) != -1) {
    panel.addWidget("org.kde.plasma.kimpanel");
}

panel.addWidget("org.kde.plasma.systemtray")
let clock = panel.addWidget("org.kde.plasma.digitalclock")
// deduced with plasma-sdk's lookandfeelexplorer
// "dateFormat": "isoDate",
// "use24hFormat": "2"
clock.writeConfig("dateFormat", "isoDate")
clock.writeConfig("use24hFormat", "2")

// panel.addWidget("org.kde.plasma.showdesktop") // not preferred





// Equip wallpaper desktop-layout.js

/*
 * FIXME: The user does not necessarily install with sudo.
 * Detect if file exists in /usr/share, or find a way to check in ~/.local/share
 * I tried using a relative path with file:// but that doesn't work either
 * Test script for future debugging:

#!/bin/bash
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();
print (allDesktops);
for (i=0;i<allDesktops.length;i++) {
    d = allDesktops[i];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
    d.writeConfig("Image", "file://home/USER/Pictures/test.png");
}'

 * Attempting to equip the wallpaper from /usr/share if the wallpaper doesn't
 * exist results in a black screen
 *
 */

// var allDesktops = desktops();
// for (i=0;i<allDesktops.length;i++) {
//     d = allDesktops[i];
//     d.wallpaperPlugin = "org.kde.image";
//     d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
//     d.currentConfigGroup["General"].writeConfig("Image", "file:///usr/share/wallpapers/Blackbriar/contents/images/3840x2160.png");
//     // d.writeConfig("Image", "file://~/.local/share/wallpapers/Blackbriar/contents/images/3840x2160.png");
//     // Note: file:// is needed.
// }