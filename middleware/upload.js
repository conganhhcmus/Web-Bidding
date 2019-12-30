// Source: https://trungquandev.com/upload-multiple-files-trong-nodejs/
// https://www.codehim.com/demo/jquery-image-uploader-preview-and-delete/

const path = require("path");
const multer = require("multer");
const MAX_FILES = 20;
const MAX_FILE_LENGTH = 32;

let storage = multer.diskStorage({
  destination: (req, file, callback) => {
    callback(null, path.join(`${__dirname}/../public/images/product`));
  },
  filename: (req, file, callback) => {
    let ext = ["image/png", "image/jpeg"];
    if (ext.indexOf(file.mimetype) === -1) {
      let errorMess = `The file <strong>${file.originalname}</strong> is invalid. Only allowed to upload image jpeg or png.`;
      return callback(errorMess, null);
    }
    // New name
    let filename = require('../utils/extensionFunc').randomChars(MAX_FILE_LENGTH) + file.originalname.substring(file.originalname.lastIndexOf('.'));
    callback(null, filename);
  }
});

module.exports = multer({storage}).array("images[]", MAX_FILES);