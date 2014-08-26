# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-onenightww

CONFIG += sailfishapp

SOURCES += src/harbour-onenightww.cpp

OTHER_FILES += qml/harbour-onenightww.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-onenightww.changes.in \
    rpm/harbour-onenightww.spec \
    rpm/harbour-onenightww.yaml \
    translations/*.ts \
    harbour-onenightww.desktop \
    qml/pages/StartPage.qml \
    qml/js/Engine.js \
    qml/GameCanvas.qml \
    qml/pages/GameBoard.qml \
    qml/Card.qml \
    qml/PlayerDialog.qml \
    qml/roles/Villager.qml \
    qml/roles/Werewolf.qml \
    qml/roles/Seer.qml \
    qml/roles/Mason.qml \
    qml/roles/Robber.qml \
    qml/roles/Drunk.qml \
    qml/roles/Minion.qml \
    qml/pages/DayDialog.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-onenightww-de.ts

