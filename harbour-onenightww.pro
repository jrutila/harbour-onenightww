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

DEPLOYMENT_PATH = /usr/share/$${TARGET}

SOURCES += src/harbour-onenightww.cpp

images.files = images
images.path = $${DEPLOYMENT_PATH}

OTHER_FILES += qml/harbour-onenightww.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SecondPage.qml \
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
    qml/roles/Robber.qml \
    qml/roles/Drunk.qml \
    qml/roles/Minion.qml \
    qml/pages/DayDialog.qml \
    qml/roles/Troublemaker.qml \
    qml/roles/Doppelganger.qml \
    qml/roles/Role.qml \
    qml/pages/PlayerDialog.qml \
    images/Werewolf.png \
    images/Troublemaker.png \
    images/Seer.png \
    images/Robber.png \
    images/Mason.png \
    images/Insomniac.png \
    images/Drunk.png \
    images/Doppelganger.png \
    images/cardback.png \
    images/Minion.png \
    qml/pages/About.qml \
    rpm/harbour-onenightww.changes

INSTALLS += images
# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/de.ts

