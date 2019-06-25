/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2018 Lukas Spies                                       **
 ** Contact: http://photoqt.org                                          **
 **                                                                      **
 ** This file is part of PhotoQt.                                        **
 **                                                                      **
 ** PhotoQt is free software: you can redistribute it and/or modify      **
 ** it under the terms of the GNU General Public License as published by **
 ** the Free Software Foundation, either version 2 of the License, or    **
 ** (at your option) any later version.                                  **
 **                                                                      **
 ** PhotoQt is distributed in the hope that it will be useful,           **
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of       **
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        **
 ** GNU General Public License for more details.                         **
 **                                                                      **
 ** You should have received a copy of the GNU General Public License    **
 ** along with PhotoQt. If not, see <http://www.gnu.org/licenses/>.      **
 **                                                                      **
 **************************************************************************/

#include "imageproviderfull.h"
#include "loader/loadimage_qt.h"
#include "loader/loadimage_gm.h"
#include "loader/loadimage_xcf.h"
#include "loader/loadimage_poppler.h"
#include "loader/loadimage_raw.h"
#include "loader/loadimage_devil.h"
#include "loader/loadimage_freeimage.h"
#include "loader/loadimage_archive.h"
#include "loader/loadimage_unrar.h"
#include "../settings/settings.h"

PQImageProviderFull::PQImageProviderFull() : QQuickImageProvider(QQuickImageProvider::Image) {

    foundExternalUnrar = -1;

}

PQImageProviderFull::~PQImageProviderFull() { }

QImage PQImageProviderFull::requestImage(const QString &filename_encoded, QSize *origSize, const QSize &requestedSize) {

    QString full_filename = QByteArray::fromPercentEncoding(filename_encoded.toUtf8());
#ifdef Q_OS_WIN
    // It is not always clear whether the file url prefix comes with two or three slashes
    // This makes sure that in Windows the file always starts with something like C:/path and not /C:/path
    while(full_filename.startsWith("/"))
        full_filename = full_filename.remove(0,1);
#endif
    QString filename = full_filename;

    QString filenameForChecking = filename;
    if(filenameForChecking.contains("::PQT::"))
        filenameForChecking = filenameForChecking.split("::PQT::").at(1);
    if(filenameForChecking.contains("::ARC::"))
        filenameForChecking = filenameForChecking.split("::ARC::").at(1);

    if(!QFileInfo(filenameForChecking).exists()) {
        QString err = QCoreApplication::translate("imageprovider", "File failed to load, it doesn't exist!");
        LOG << CURDATE << "ImageProviderFull: ERROR: " << err.toStdString() << NL;
        LOG << CURDATE << "ImageProviderFull: Filename: " << filenameForChecking.toStdString() << NL;
        return PQLoadImage::ErrorImage::load(err);
    }

    // Which GraphicsEngine should we use?
    QString whatToUse = PQLoadImage::Helper::whatEngineDoIUse(filename);

    // The return image
    QImage ret;

    QString err = "";

    if(whatToUse == "gm") {
        ret = PQLoadImage::GraphicsMagick::load(filename, requestedSize, origSize);
        err = PQLoadImage::GraphicsMagick::errormsg;
    } else if(whatToUse == "xcftools") {
        ret = PQLoadImage::XCF::load(filename, requestedSize, origSize);
        err = PQLoadImage::XCF::errormsg;
    } else if(whatToUse == "poppler") {
        ret = PQLoadImage::PDF::load(filename, requestedSize, origSize);
        err = PQLoadImage::PDF::errormsg;
    } else if(whatToUse == "raw") {
        ret = PQLoadImage::Raw::load(filename, requestedSize, origSize);
        err = PQLoadImage::Raw::errormsg;
    } else if(whatToUse == "devil") {
        ret = PQLoadImage::DevIL::load(filename, requestedSize, origSize);
        err = PQLoadImage::DevIL::errormsg;
    } else if(whatToUse == "freeimage") {
        ret = PQLoadImage::FreeImage::load(filename, requestedSize, origSize);
        err = PQLoadImage::FreeImage::errormsg;
    } else if(whatToUse == "unrar") {
        ret = PQLoadImage::UNRAR::load(filename, requestedSize, origSize);
        err = PQLoadImage::UNRAR::errormsg;
    } else if(whatToUse == "archive") {
        ret = PQLoadImage::Archive::load(filename, requestedSize, origSize);
        err = PQLoadImage::Archive::errormsg;
    } else {
        ret = PQLoadImage::Qt::load(filename, requestedSize, origSize);
        err = PQLoadImage::Qt::errormsg;
    }

    // if returned image is not an error image ...
    if(ret.isNull())
        return PQLoadImage::ErrorImage::load(err);

    // return scaled version
    if(requestedSize.width() > 2 && requestedSize.height() > 2 && origSize->width() > requestedSize.width() && origSize->height() > requestedSize.height())
        return ret.scaled(requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);

    // return full version
    return ret;

}

QByteArray PQImageProviderFull::getUniqueCacheKey(QString path) {
    path = path.remove("image://full/");
    path = path.remove("file:/");
    QFileInfo info(path);
    QString fn = QString("%1%2").arg(path).arg(info.lastModified().toMSecsSinceEpoch());
    return QCryptographicHash::hash(fn.toUtf8(),QCryptographicHash::Md5).toHex();
}
