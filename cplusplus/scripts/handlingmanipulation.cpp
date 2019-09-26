#include "handlingmanipulation.h"

PQHandlingManipulation::PQHandlingManipulation(QObject *parent) : QObject(parent) { }

QSize PQHandlingManipulation::getCurrentImageResolution(QString filename) {

    QImageReader reader(filename);
    return reader.size();

}

bool PQHandlingManipulation::canThisBeScaled(QString filename) {

    // These image formats known by exiv2 are also supported by PhotoQt
    QStringList formats;
    formats << "jpeg"
            << "jpg"
            << "tif"
            << "tiff"
            << "png"
            << "psd"
            << "jpeg2000"
            << "jp2"
            << "jpc"
            << "j2k"
            << "jpf"
            << "jpx"
            << "jpm"
            << "mj2"
            << "bmp"
            << "bitmap"
            << "gif"
            << "tga";

    return formats.contains(QFileInfo(filename).suffix().toLower());

}

bool PQHandlingManipulation::scaleImage(QString sourceFilename, bool scaleInPlace, QSize targetSize, int targetQuality) {

    if(!canThisBeScaled(sourceFilename)) {
        LOG << CURDATE << "PQHandlingManipulation::scaleImage: ERROR file '" << sourceFilename.toStdString() << "' not supported for scaling" << NL;
        return false;
    }

#ifdef EXIV2

    // This will store all the exif data
    Exiv2::ExifData exifData;
    Exiv2::IptcData iptcData;
    Exiv2::XmpData xmpData;
    bool gotExifData = false;

    try {

        // Open image for exif reading
        Exiv2::Image::AutoPtr image_read = Exiv2::ImageFactory::open(sourceFilename.toStdString());

        if(image_read.get() != 0) {

            // YAY, WE FOUND SOME!!!!!
            gotExifData = true;

            // read exif
            image_read->readMetadata();
            exifData = image_read->exifData();
            iptcData = image_read->iptcData();
            xmpData = image_read->xmpData();

            // Update dimensions
            exifData["Exif.Photo.PixelXDimension"] = int32_t(targetSize.width());
            exifData["Exif.Photo.PixelYDimension"] = int32_t(targetSize.height());

        }

    }

    catch (Exiv2::Error& e) {
        LOG << CURDATE << "PQHandlingManipulation::scaleImage: ERROR reading exif data (caught exception): " << e.what() << NL;
    }

#endif

    // We need to do the actual scaling in between reading the exif data above and writing it below,
    // since we might be scaling the image in place and thus would overwrite old exif data
    QImageReader reader(sourceFilename);
    reader.setScaledSize(QSize(targetSize.width(),targetSize.height()));
    QImage img = reader.read();

    QString targetFilename = sourceFilename;
    if(!scaleInPlace) {
        QFileInfo info(sourceFilename);
        targetFilename = QString("%1/%2_%3x%4.%5").arg(info.absolutePath())
                                                  .arg(info.baseName())
                                                  .arg(targetSize.width())
                                                  .arg(targetSize.height())
                                                  .arg(info.suffix());
    }

    if(!img.save(targetFilename, 0, targetQuality)) {
        LOG << CURDATE << "PQHandlingManipulation::scaleImage: ERROR: Unable to save scaled image file" << NL;
        return false;
    }

#ifdef EXIV2

    if(gotExifData) {

        try {

            // And write exif data to new image file
            Exiv2::Image::AutoPtr image_write = Exiv2::ImageFactory::open(targetFilename.toStdString());
            image_write->setExifData(exifData);
            image_write->setIptcData(iptcData);
            image_write->setXmpData(xmpData);
            image_write->writeMetadata();

        }

        catch (Exiv2::Error& e) {
            LOG << CURDATE << "PQHandlingManipulation::scaleImage: ERROR writing exif data (caught exception): " << e.what() << NL;
        }

    }

#endif

    return true;

}