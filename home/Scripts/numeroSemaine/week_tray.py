#!/usr/bin/env python3
import sys
from datetime import date

from PySide6.QtCore import Qt, QTimer
from PySide6.QtGui import QPixmap, QPainter, QFont, QColor, QIcon
from PySide6.QtWidgets import QApplication, QSystemTrayIcon


def iso_week() -> int:
    return date.today().isocalendar().week


def make_text_icon(text: str, size: int = 24) -> QIcon:
    pix = QPixmap(size, size)
    pix.fill(Qt.transparent)

    p = QPainter(pix)
    p.setRenderHint(QPainter.TextAntialiasing, True)

    font = QFont()
    font.setBold(True)
    font.setPointSize(int(size * 0.45))
    p.setFont(font)

    # petite ombre pour lisibilité
    p.setPen(QColor(0, 0, 0, 160))
    p.drawText(pix.rect().adjusted(1, 1, 1, 1), Qt.AlignCenter, text)

    p.setPen(QColor(235, 235, 235))
    p.drawText(pix.rect(), Qt.AlignCenter, text)
    p.end()

    return QIcon(pix)


def main():
    app = QApplication(sys.argv)
    app.setQuitOnLastWindowClosed(False)

    tray = QSystemTrayIcon()
    tray.setVisible(True)

    def refresh():
        w = iso_week()
        tray.setIcon(make_text_icon(f"{w:02d}", size=28))

    refresh()

    # rafraîchit toutes les 10 minutes (simple et suffisant)
    t = QTimer()
    t.timeout.connect(refresh)
    t.start(10 * 60 * 1000)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
