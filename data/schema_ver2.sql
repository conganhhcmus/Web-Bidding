CREATE DATABASE AUCTION;
USE AUCTION;

/*==============================================================*/
/* Table: AUCTION_HISTORY                                       */
/*==============================================================*/
create table AUCTION_HISTORY
(
   ID                   int(11) unsigned not null auto_increment  comment '',
   PRODUCT_ID           int(11) unsigned not null  comment '',
   USER_ID              int(11) unsigned not null  comment '',
   TIME                 datetime not null  comment '',
   PRICE                bigint(20) not null  comment '',
   primary key (ID)
)
ENGINE = InnoDB
CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

/*==============================================================*/
/* Table: CATEGORY                                              */
/*==============================================================*/
create table CATEGORY
(
   ID                   int(11) unsigned not null auto_increment  comment '',
   PARENT_ID            int(11) unsigned  comment '',
   CAT_NAME             varchar(50) not null  comment '',
   primary key (ID)
)
ENGINE = InnoDB
CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

/*==============================================================*/
/* Table: IMAGE                                                 */
/*==============================================================*/
create table IMAGE
(
   ID                   int(11) unsigned not null auto_increment comment '',
   ORIGINAL_NAME        varchar(128)  comment '',
   HASH_NAME            varchar(50) not null  comment '',
   PRODUCT_ID           int(11) unsigned  comment '',
   primary key (ID)
)
ENGINE = InnoDB
CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

/*==============================================================*/
/* Table: PRODUCT                                               */
/*==============================================================*/
create table PRODUCT
(
   ID                   int(11) unsigned not null auto_increment comment '',
   CAT_ID               int(11) unsigned not null  comment '',
   SELLER_ID            int(11) unsigned not null  comment '',
   MAIN_IMAGE           int(11) unsigned  comment '',
   PRODUCT_NAME         varchar(200) not null  comment '',
   CURRENT_PRICE        bigint(20)  comment '',
   START_TIME           datetime not null  comment '',
   END_TIME             datetime not null  comment '',
   DESCRIPTION          text  comment '',
   BUYNOW_PRICE         bigint(20)  comment '',
   BUYNOW_FLAG          tinyint(1) not null default 0  comment '',
   STARTING_PRICE       bigint(20) not null  comment '',
   BIDDING_INCREMENT    bigint(20) not null  comment '',
   EXTENSION_FLAG       tinyint(1) not null default 0  comment '',
   TIME					datetime not null,
   primary key (ID)
)
ENGINE = InnoDB
CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

/*==============================================================*/
/* Table: RATING                                                */
/*==============================================================*/
create table RATING
(
   ID                   int(11) unsigned not null auto_increment  comment '',
   PRODUCT_ID           int(11) unsigned not null  comment '',
   RATING_FOR           int(11) unsigned not null  comment '',
   RATED_BY             int(11) unsigned not null  comment '',
   CONTENT              text not null  comment '',
   TIME                 datetime not null  comment '',
   POINT                tinyint(1) not null  comment '',
   primary key (ID)
)
ENGINE = InnoDB
CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

/*==============================================================*/
/* Table: USER                                                  */
/*==============================================================*/
create table USER
(
   ID                   int(11) unsigned not null auto_increment  comment '',
   USERNAME             varchar(50) not null comment '',
   PASSWORD             varchar(255) not null  comment '',
   FULL_NAME            varchar(50) not null comment '',
   EMAIL                varchar(50) not null comment '',
   DOB                  date  comment '',
   PERMISSION           int(11) not null comment '',
   TIME                 datetime not null comment '',
   primary key (ID)
)
ENGINE = InnoDB
CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

/*==============================================================*/
/* Table: WATCH_LIST                                            */
/*==============================================================*/
create table WATCH_LIST
(
   ID                   int(11) unsigned not null auto_increment comment '',
   TIME                 datetime not null  comment '',
   USER_ID              int(11) unsigned not null  comment '',
   PRODUCT_ID           int(11) unsigned not null  comment '',
   primary key (ID)
)
ENGINE = InnoDB
CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

alter table AUCTION_HISTORY add constraint FK_AUCTION_HISTORY_REFERENCE_PRODUCT foreign key (PRODUCT_ID)
      references PRODUCT (ID) on delete restrict on update restrict;

alter table AUCTION_HISTORY add constraint FK_AUCTION_HISTORY_REFERENCE_USER foreign key (USER_ID)
      references USER (ID) on delete restrict on update restrict;

alter table CATEGORY add constraint FK_CATEGORY_REFERENCE_CATEGORY foreign key (PARENT_ID)
      references CATEGORY (ID) on delete restrict on update restrict;

alter table IMAGE add constraint FK_IMAGE_REFERENCE_PRODUCT foreign key (PRODUCT_ID)
      references PRODUCT (ID) on delete restrict on update restrict;

alter table PRODUCT add constraint FK_PRODUCT_REFERENCE_CATEGORY foreign key (CAT_ID)
      references CATEGORY (ID) on delete restrict on update restrict;

alter table PRODUCT add constraint FK_PRODUCT_REFERENCE_IMAGE foreign key (MAIN_IMAGE)
      references IMAGE (ID) on delete restrict on update restrict;

alter table PRODUCT add constraint FK_PRODUCT_REFERENCE_USER foreign key (SELLER_ID)
      references USER (ID) on delete restrict on update restrict;

alter table RATING add constraint FK_RATING_REFERENCE_USER foreign key (RATING_FOR)
      references USER (ID) on delete restrict on update restrict;

alter table RATING add constraint FK_RATING_REFERENCE_2_USER foreign key (RATED_BY)
      references USER (ID) on delete restrict on update restrict;

alter table RATING add constraint FK_RATING_REFERENCE_PRODUCT foreign key (PRODUCT_ID)
      references PRODUCT (ID) on delete restrict on update restrict;

alter table WATCH_LIST add constraint FK_WATCH_LIST_REFERENCE_USER foreign key (USER_ID)
      references USER (ID) on delete restrict on update restrict;

alter table WATCH_LIST add constraint FK_WATCH_LIST_REFERENCE_PRODUCT foreign key (PRODUCT_ID)
      references PRODUCT (ID) on delete restrict on update restrict;

COMMIT;
alter table PRODUCT add fulltext (PRODUCT_NAME);
COMMIT;

USE AUCTION;

INSERT INTO category VALUES(1, null, 'Điện tử');
INSERT INTO category VALUES(2, 1, 'Điện thoại di động');
INSERT INTO category VALUES(3, 1, 'Máy tính xách tay');
INSERT INTO category VALUES(4, 1, 'Đồng hồ đeo tay');
INSERT INTO category VALUES(5, null, 'Điện lạnh');
INSERT INTO category VALUES(6, 5, 'Tủ lạnh');
INSERT INTO category VALUES(7, 1, 'Phụ kiện');
INSERT INTO category VALUES(8, 1, 'Tablet');

insert into user values(1, 'admin', '$2b$10$znBCq/j4NYU6wKCr5YR8Re5zFtq9Lv9VWWT1p1ZW4lzF9BlYGVDIi', 'Admin', 'admin@domain.com', '1999-01-01', 2, '2019-12-24 00:00:00');

COMMIT;


INSERT INTO product VALUES (1, 3, 1, null, 'Laptop Apple Macbook Air 2019 i5 1.6GHz/8GB/128GB (MVFM2SA/A)', 27990000, '2019-12-24 12:00:00', '2020-01-01 12:00:00',
CONCAT('Bộ xử lý\r\n',
'Công nghệ CPU	Intel Core i5 Coffee Lake\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'RAM	8 GB\r\n',
'Loại RAM	DDR3\r\n',
'\r\n',
'\r\n',
'\r\n',
'Màn hình\r\n',
'Kích thước màn hình	13.3 inch\r\n',
'Độ phân giải	Retina (2560 x 1600)\r\n',
'Công nghệ màn hình	Công nghệ IPS, LED Backlit\r\n',
'Màn hình cảm ứng	Không\r\n',
'\r\n',
'\r\n',
'\r\n',
'Công nghệ âm thanh	3 microphones, Headphones, Loa kép (2 kênh)\r\n',
'\r\n',
'Cổng giao tiếp	2 x Thunderbolt 3 (USB-C)\r\n',
'\r\n',
'\r\n',
'\r\n',
'Webcam	FaceTime Camera\r\n',
'Đèn bàn phím	Có\r\n',
'\r\n',
'PIN\r\n',
'Loại PIN	PIN liền\r\n',
'Thông tin Pin	Khoảng 10 giờ\r\n',
'\r\n',
'\r\n',
'Kích thước & trọng lượng\r\n',
'\r\n',
'Trọng lượng	1.25 kg\r\n'), null, 0, 27990000, 50000, 0, '2019-12-24 00:01:00');










INSERT INTO product VALUES (2, 3, 1, null, 'Laptop Lenovo Ideapad S145 15IWL i3 8145U/4GB/256GB/2GB MX110/Win10 (81MV00SXVN)', 10490000, '2019-12-24 12:00:00', '2020-01-01 12:00:00',
CONCAT('Bộ xử lý\r\n',
'Công nghệ CPU	Intel Core i3 Coffee Lake\r\n',
'Loại CPU	8145U\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'RAM	4 GB\r\n',
'Loại RAM	DDR4 (On board +1 khe)\r\n',
'\r\n',
'\r\n',
'\r\n',
'Màn hình\r\n',
'Kích thước màn hình	15.6 inch\r\n',
'Độ phân giải	Full HD (1920 x 1080)\r\n',
'Công nghệ màn hình	Tấm nền TN, 60Hz, Anti-Glare\r\n',
'Màn hình cảm ứng	Không\r\n',
'\r\n',
'\r\n',
'\r\n',
'Công nghệ âm thanh	Dolby Home Theater\r\n',
'\r\n',
'Cổng giao tiếp	2 x USB 3.0, HDMI, USB 2.0\r\n',
'\r\n',
'\r\n',
'\r\n',
'Webcam	HD webcam\r\n',
'Đèn bàn phím	Không\r\n',
'Tính năng khác	Không\r\n',
'PIN\r\n',
'Loại PIN	PIN liền\r\n',
'Thông tin Pin	Li-Ion 2 cell\r\n',
'\r\n',
'\r\n',
'Kích thước & trọng lượng\r\n',
'Kích thước	Dài 362 mm - Rộng 251.4 mm - Dày 19.9mm\r\n',
'Trọng lượng	1.73 kg\r\n',
'Chất liệu	Vỏ nhựa\r\n'), null, 0, 10490000, 50000, 0, '2019-12-24 00:02:00');










INSERT INTO product VALUES (3, 3, 1, null, 'Laptop Acer Swift 3 SF315 52 38YQ i3 8130U/4GB/1TB/Win10 (NX.GZBSV.003)', 11490000, '2019-12-24 12:00:00', '2020-01-02 12:00:00',
CONCAT('Bộ xử lý\r\n',
'Công nghệ CPU	Intel Core i3 Coffee Lake\r\n',
'Loại CPU	8130U\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'RAM	4 GB\r\n',
'Loại RAM	DDR4 (2 khe)\r\n',
'\r\n',
'\r\n',
'\r\n',
'Màn hình\r\n',
'Kích thước màn hình	15.6 inch\r\n',
'Độ phân giải	Full HD (1920 x 1080)\r\n',
'Công nghệ màn hình	Tấm nền IPS, Acer ComfyView\r\n',
'Màn hình cảm ứng	Không\r\n',
'\r\n',
'\r\n',
'\r\n',
'Công nghệ âm thanh	Acer TrueHarmony\r\n',
'\r\n',
'Cổng giao tiếp	2 x USB 3.0, HDMI, USB 2.0, USB Type-C\r\n',
'\r\n',
'\r\n',
'\r\n',
'Webcam	HD webcam\r\n',
'Đèn bàn phím	Có\r\n',
'Tính năng khác	Bảo mật vân tay\r\n',
'PIN\r\n',
'Loại PIN	PIN liền\r\n',
'Thông tin Pin	Li-Ion 4 cell\r\n',
'\r\n',
'\r\n',
'Kích thước & trọng lượng\r\n',
'Kích thước	Dài 359 mm - Rộng 243 mm - Dày 16.9 mm\r\n',
'Trọng lượng	1.7 kg\r\n',
'Chất liệu	Vỏ kim loại\r\n'), null, 0, 11490000, 50000, 0, '2019-12-24 00:03:00');








INSERT INTO product VALUES (4, 3, 1, null, 'Laptop Dell Vostro 5490 i5 10210U/8GB/256GB/Win10 (V4I5106W)', 19490000, '2019-12-24 12:00:00', '2020-01-03 12:00:00',
CONCAT('Bộ xử lý\r\n',
'Công nghệ CPU	Intel Core i5 Comet Lake\r\n',
'Loại CPU	10210U\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'RAM	8 GB\r\n',
'Loại RAM	DDR4 (On board +1 khe)\r\n',
'\r\n',
'\r\n',
'\r\n',
'Màn hình\r\n',
'Kích thước màn hình	14 inch\r\n',
'Độ phân giải	Full HD (1920 x 1080)\r\n',
'Công nghệ màn hình	60Hz, Tấm nền TN, Anti-Glare\r\n',
'Màn hình cảm ứng	Không\r\n',
'\r\n',
'\r\n',
'\r\n',
'Công nghệ âm thanh	Realtek High Definition Audio\r\n',
'\r\n',
'Cổng giao tiếp	2 x USB 3.1, HDMI, LAN (RJ45), USB 2.0, USB Type-C\r\n',
'\r\n',
'\r\n',
'\r\n',
'Webcam	HD webcam\r\n',
'Đèn bàn phím	Có\r\n',
'Tính năng khác	Không\r\n',
'PIN\r\n',
'Loại PIN	PIN liền\r\n',
'Thông tin Pin	Li-Ion 3 cell\r\n',
'\r\n',
'\r\n',
'Kích thước & trọng lượng\r\n',
'Kích thước	Dài 328 mm - Rộng 227.7 mm - Dày 18.3 mm\r\n',
'Trọng lượng	1.49 kg\r\n',
'Chất liệu	Vỏ nhựa - nắp lưng bằng kim loại\r\n'), null, 0, 19490000, 50000, 0, '2019-12-24 00:04:00');











INSERT INTO product VALUES (5, 3, 1, null, 'Laptop MSI Gaming 15 GF63 9SC i7 9750H/8GB/256GB/4GB GTX1650/Win10 (070VN)', 25490000, '2019-12-24 12:00:00', '2020-01-06 12:00:00',
CONCAT('Bộ xử lý\r\n',
'Công nghệ CPU	Intel Core i7 Coffee Lake\r\n',
'Loại CPU	9750H\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'RAM	8 GB\r\n',
'Loại RAM	DDR4 (2 khe)\r\n',
'\r\n',
'\r\n',
'\r\n',
'Màn hình\r\n',
'Kích thước màn hình	15.6 inch\r\n',
'Độ phân giải	Full HD (1920 x 1080)\r\n',
'\r\n',
'Màn hình cảm ứng	Không\r\n',
'\r\n',
'\r\n',
'\r\n',
'Công nghệ âm thanh	Nahimic 3\r\n',
'\r\n',
'Cổng giao tiếp	HDMI 2.0, 3 x USB 3.1, LAN (RJ45), USB Type-C\r\n',
'\r\n',
'\r\n',
'\r\n',
'Webcam	HD webcam\r\n',
'Đèn bàn phím	Có\r\n',
'Tính năng khác	Không\r\n',
'PIN\r\n',
'Loại PIN	PIN liền\r\n',
'Thông tin Pin	Li - Polymer 3 cell\r\n',
'\r\n',
'\r\n',
'Kích thước & trọng lượng\r\n',
'Kích thước	Dài 359 mm - Rộng 254 mm - Dày 21.7 mm\r\n',
'Trọng lượng	1.86 kg\r\n',
'Chất liệu	Vỏ kim loại\r\n'), null, 0, 25490000, 50000, 0, '2019-12-24 00:05:00');









INSERT INTO product VALUES (6, 2, 1, null, 'Oppo A5 2020 64GB', 4290000, '2019-12-24 12:00:00', '2020-01-05 12:00:00', CONCAT('Màn hình\r\n',
'Công nghệ màn hình	TFT\r\n',
'Độ phân giải	HD+ (720 x 1600 Pixels)\r\n',
'Màn hình rộng	6.5"\r\n',
'Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 3\r\n',
'Camera sau\r\n',
'Độ phân giải	Chính 12 MP & Phụ 8 MP, 2 MP, 2 MP\r\n',
'Quay phim	Quay phim HD 720p@30fps, Quay phim FullHD 1080p@30fps, Quay phim 4K 2160p@30fps\r\n',
'Đèn Flash	Có\r\n',
'\r\n',
'Camera trước\r\n',
'Độ phân giải	8 MP\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'Chipset (hãng SX CPU)	Snapdragon 665 8 nhân\r\n',
'\r\n',
'\r\n',
'Bộ nhớ & Lưu trữ\r\n',
'RAM	4 GB\r\n',
'Bộ nhớ trong	128 GB\r\n',
'Bộ nhớ còn lại (khả dụng)	Khoảng 104 GB\r\n',
'\r\n',
'\r\n',
'\r\n',
'SIM	2 Nano SIM\r\n',
'Wifi	Wi-Fi 802.11 a/b/g/n/ac, DLNA, Wi-Fi Direct, Wi-Fi hotspot\r\n',
'GPS	BDS, A-GPS, GLONASS\r\n',
'Bluetooth	LE, A2DP, v5.0\r\n',
'Cổng kết nối/sạc	USB Type-C\r\n',
'Jack tai nghe	3.5 mm\r\n',
'\r\n',
'Thiết kế & Trọng lượng\r\n',
'\r\n',
'Chất liệu	Khung & Mặt lưng nhựa\r\n',
'Kích thước	Dài 163.6 mm - Ngang 75.6 mm - Dày 9.1 mm\r\n',
'Trọng lượng	195 g\r\n',
'Thông tin pin & Sạc\r\n',
'Dung lượng pin	5000 mAh\r\n',
'Loại pin	Pin chuẩn Li-Po\r\n',
'Công nghệ pin	Tiết kiệm pin\r\n',
'Tiện ích\r\n',
'Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt\r\n',
'\r\n',
'Nhân bản ứng dụng\r\n',
'Không gian trẻ em\r\n',
'\r\n',
'Không gian trò chơi\r\n',
'Mặt kính 2.5D\r\n',
'Chặn tin nhắn\r\n',
'\r\n',
'Chặn cuộc gọi\r\n',
'Đèn pin\r\n',
'Dolby Audio™\r\n',
'Trợ lý ảo Google Assistant\r\n',
'Ghi âm	Có\r\n',
'Radio	Có\r\n',
'Xem phim	MP4, AVI, WMV, H.264(MPEG4-AVC)\r\n',
'Nghe nhạc	AMR, MP3, WAV, eAAC+\r\n',
'Thông tin khác\r\n',
'\r\n'), null, 0, 4290000, 50000, 0, '2019-12-24 00:06:00');



INSERT INTO product VALUES (7, 2, 1, null, 'iPhone 11 64GB', 21990000, '2019-12-24 12:00:00', '2020-01-05 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	IPS LCD\r\n',
'Độ phân giải	828 x 1792 Pixels\r\n',
'Màn hình rộng	6.1"\r\n',
'Mặt kính cảm ứng	Kính cường lực oleophobic (ion cường lực)\r\n',
'Camera sau\r\n',
'Độ phân giải	Chính 12 MP & Phụ 12 MP\r\n',
'Quay phim	Quay phim HD 720p@30fps, Quay phim FullHD 1080p@30fps, Quay phim FullHD 1080p@60fps, Quay phim FullHD 1080p@120fps, Quay phim FullHD 1080p@240fps, Quay phim 4K 2160p@24fps, Quay phim 4K 2160p@30fps, Quay phim 4K 2160p@60fps\r\n',
'\r\n',
'\r\n',
'Camera trước\r\n',
'Độ phân giải	12 MP\r\n',
'Videocall	Có\r\n',
'\r\n',
'\r\n',
'\r\n',
'Chipset (hãng SX CPU)	Apple A13 Bionic 6 nhân\r\n',
'\r\n',
'\r\n',
'Bộ nhớ & Lưu trữ\r\n',
'RAM	4 GB\r\n',
'Bộ nhớ trong	128 GB\r\n',
'Bộ nhớ còn lại (khả dụng)	Khoảng 123 GB\r\n',
'Thẻ nhớ ngoài	Không\r\n',
'\r\n',
'\r\n',
'SIM	1 eSIM & 1 Nano SIM\r\n',
'Wifi	Dual-band, Wi-Fi 802.11 a/b/g/n/ac/ax, Wi-Fi hotspot\r\n',
'GPS	BDS, A-GPS, GLONASS\r\n',
'Bluetooth	LE, A2DP, v5.0\r\n',
'Cổng kết nối/sạc	Lightning\r\n',
'Jack tai nghe	Lightning\r\n',
'\r\n',
'Thiết kế & Trọng lượng\r\n',
'\r\n',
'Chất liệu	Khung nhôm & Mặt lưng kính cường lực\r\n',
'Kích thước	Dài 150.9 mm - Ngang 75.7 mm - Dày 8.3 mm\r\n',
'Trọng lượng	194 g\r\n',
'Thông tin pin & Sạc\r\n',
'Dung lượng pin	3110 mAh\r\n',
'Loại pin	Pin chuẩn Li-Ion\r\n',
'Công nghệ pin	Tiết kiệm pin, Sạc pin nhanh, Sạc pin không dây\r\n',
'Tiện ích\r\n',
'Bảo mật nâng cao	Mở khoá khuôn mặt Face ID\r\n',
'\r\n',
'Dolby Audio™\r\n',
'Chuẩn Kháng nước, Chuẩn kháng bụi\r\n',
'Sạc pin không dây\r\n',
'Sạc pin nhanh\r\n',
'Apple Pay\r\n',
'\r\n',
'Radio	Không\r\n',
'Xem phim	H.264(MPEG4-AVC)\r\n',
'Nghe nhạc	Lossless, MP3, AAC, FLAC\r\n',
'Thông tin khác\r\n',
'\r\n'), 22000000, 1, 21990000, 100000, 0, '2019-12-24 00:07:00');




INSERT INTO product VALUES (8, 2, 1, null, 'Samsung Galaxy S10 plus 128GB', 22990000, '2019-12-24 12:00:00', '2020-01-05 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	Dynamic AMOLED\r\n',
'Độ phân giải	2K+ (1440 x 3040 Pixels)\r\n',
'Màn hình rộng	6.4"\r\n',
'Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 6\r\n',
'Camera sau\r\n',
'Độ phân giải	Chính 12 MP & Phụ 12 MP, 16 MP\r\n',
'Quay phim	Quay phim siêu chậm 960 fps, Quay phim FullHD 1080p@240fps, Quay phim 4K 2160p@60fps\r\n',
'Đèn Flash	Có\r\n',
'\r\n',
'Camera trước\r\n',
'Độ phân giải	Chính 10 MP & Phụ 8 MP\r\n',
'Videocall	Có\r\n',
'\r\n',
'\r\n',
'\r\n',
'Chipset (hãng SX CPU)	Exynos 9820 8 nhân\r\n',
'\r\n',
'\r\n',
'Bộ nhớ & Lưu trữ\r\n',
'RAM	8 GB\r\n',
'Bộ nhớ trong	512 GB\r\n',
'Bộ nhớ còn lại (khả dụng)	Khoảng 480 GB\r\n',
'\r\n',
'\r\n',
'\r\n',
'SIM	2 SIM Nano (SIM 2 chung khe thẻ nhớ)\r\n',
'Wifi	Dual-band, Wi-Fi 802.11 a/b/g/n/ac/ax, Wi-Fi Direct, Wi-Fi hotspot\r\n',
'GPS	BDS, A-GPS, GLONASS\r\n',
'Bluetooth	A2DP, LE, apt-X, v5.0\r\n',
'Cổng kết nối/sạc	USB Type-C\r\n',
'Jack tai nghe	3.5 mm\r\n',
'\r\n',
'Thiết kế & Trọng lượng\r\n',
'\r\n',
'Chất liệu	Khung kim loại & Mặt lưng kính cường lực\r\n',
'Kích thước	Dài 157.6 mm - Ngang 74.1 mm - Dày 7.8 mm\r\n',
'Trọng lượng	175 g\r\n',
'Thông tin pin & Sạc\r\n',
'Dung lượng pin	4100 mAh\r\n',
'Loại pin	Pin chuẩn Li-Ion\r\n',
'Công nghệ pin	Tiết kiệm pin, Siêu tiết kiệm pin, Sạc pin nhanh, Sạc pin không dây, Sạc ngược không dây\r\n',
'Tiện ích\r\n',
'Bảo mật nâng cao	Mở khoá khuôn mặt, Mở khoá vân tay dưới màn hình\r\n',
'\r\n',
'Samsung Pay\r\n',
'Nhân bản ứng dụng\r\n',
'Samsung DeX\r\n',
'Dolby Audio™\r\n',
'Trợ lý ảo Samsung Bixby\r\n',
'Màn hình luôn hiển thị AOD\r\n',
'Chặn tin nhắn\r\n',
'Ghi âm cuộc gọi\r\n',
'Chặn cuộc gọi\r\n',
'Sạc pin nhanh\r\n',
'Chạm 2 lần sáng màn hình\r\n',
'Chuẩn Kháng nước, Chuẩn kháng bụi\r\n',
'Đèn pin\r\n',
'\r\n',
'Radio	Không\r\n',
'Xem phim	H.265, 3GP, MP4, AVI, WMV, H.264(MPEG4-AVC), DivX, WMV9, Xvid\r\n',
'Nghe nhạc	Lossless, Midi, MP3, WAV, WMA, AAC++, eAAC+, OGG, AC3, FLAC\r\n',
'Thông tin khác\r\n',
'\r\n'), null, 0, 22990000, 100000, 0, '2019-12-24 00:08:00');




INSERT INTO product VALUES (9, 2, 1, null, 'BlackBerry Key 2', 15990000, '2019-12-24 12:00:00', '2020-01-05 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	IPS LCD\r\n',
'Độ phân giải	1080 x 1620 Pixels\r\n',
'Màn hình rộng	4.5"\r\n',
'Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 3\r\n',
'Camera sau\r\n',
'Độ phân giải	Chính 12 MP & Phụ 12 MP\r\n',
'Quay phim	Quay phim 4K 2160p@30fps\r\n',
'Đèn Flash	Đèn LED 2 tông màu\r\n',
'\r\n',
'Camera trước\r\n',
'Độ phân giải	8 MP\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'Chipset (hãng SX CPU)	Snapdragon 660 8 nhân\r\n',
'\r\n',
'\r\n',
'Bộ nhớ & Lưu trữ\r\n',
'RAM	6 GB\r\n',
'Bộ nhớ trong	64 GB\r\n',
'Bộ nhớ còn lại (khả dụng)	Đang cập nhật\r\n',
'\r\n',
'\r\n',
'\r\n',
'SIM	2 Nano SIM\r\n',
'Wifi	Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi Direct, Wi-Fi hotspot\r\n',
'GPS	BDS, A-GPS, GLONASS\r\n',
'Bluetooth	LE, v5.0\r\n',
'Cổng kết nối/sạc	USB Type-C\r\n',
'Jack tai nghe	3.5 mm\r\n',
'\r\n',
'Thiết kế & Trọng lượng\r\n',
'\r\n',
'Chất liệu	Khung kim loại & Mặt lưng kính cường lực\r\n',
'Kích thước	Dài 151.4 mm - Ngang 71.8 mm - Dày 8.5 mm\r\n',
'Trọng lượng	168 g\r\n',
'Thông tin pin & Sạc\r\n',
'Dung lượng pin	3500 mAh\r\n',
'Loại pin	Pin chuẩn Li-Ion\r\n',
'Công nghệ pin	Tiết kiệm pin, Sạc nhanh Quick Charge 3.0\r\n',
'Tiện ích\r\n',
'Bảo mật nâng cao	Mở khóa bằng vân tay\r\n',
'\r\n',
'\r\n',
'Radio	Có\r\n',
'Xem phim	3GP, AVI, H.264(MPEG4-AVC), DivX\r\n',
'Nghe nhạc	MP3, WAV, AAC, OGG, FLAC\r\n',
'Thông tin khác\r\n'), 17000000, 1, 15990000, 50000, 0, '2019-12-24 00:09:00');







INSERT INTO product VALUES (10, 2, 1, null, 'Xiaomi Mi Note 10 Pro', 14490000, '2019-12-24 12:00:00', '2020-01-01 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	AMOLED\r\n',
'Độ phân giải	Full HD+ (1080 x 2340 Pixels)\r\n',
'Màn hình rộng	6.47"\r\n',
'Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 5\r\n',
'Camera sau\r\n',
'Độ phân giải	Chính 108 MP & Phụ 20 MP, 12 MP, 5 MP, 2 MP\r\n',
'Quay phim	Quay phim HD 720p@960fps, Quay phim FullHD 1080p@30fps, Quay phim FullHD 1080p@60fps, Quay phim FullHD 1080p@120fps, Quay phim FullHD 1080p@240fps, Quay phim 4K 2160p@30fps\r\n',
'\r\n',
'\r\n',
'Camera trước\r\n',
'Độ phân giải	32 MP\r\n',
'\r\n',
'\r\n',
'\r\n',
'\r\n',
'Chipset (hãng SX CPU)	Snapdragon 730G 8 nhân\r\n',
'\r\n',
'\r\n',
'Bộ nhớ & Lưu trữ\r\n',
'RAM	8 GB\r\n',
'Bộ nhớ trong	256 GB\r\n',
'Bộ nhớ còn lại (khả dụng)	Đang cập nhật\r\n',
'Thẻ nhớ ngoài	Không\r\n',
'\r\n',
'\r\n',
'SIM	2 Nano SIM\r\n',
'Wifi	Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi Direct, Wi-Fi hotspot\r\n',
'GPS	BDS, A-GPS, GLONASS\r\n',
'Bluetooth	apt-X, A2DP, LE, v5.0\r\n',
'Cổng kết nối/sạc	USB Type-C\r\n',
'Jack tai nghe	3.5 mm\r\n',
'\r\n',
'Thiết kế & Trọng lượng\r\n',
'\r\n',
'Chất liệu	Khung kim loại & Mặt lưng kính cường lực\r\n',
'Kích thước	Dài 157.8 mm - Ngang 74.2 mm - Dày 9.67 mm\r\n',
'Trọng lượng	208 g\r\n',
'Thông tin pin & Sạc\r\n',
'Dung lượng pin	5260 mAh\r\n',
'Loại pin	Pin chuẩn Li-Po\r\n',
'Công nghệ pin	Tiết kiệm pin, Siêu tiết kiệm pin, Sạc pin nhanh\r\n',
'Tiện ích\r\n',
'Bảo mật nâng cao	Mở khoá khuôn mặt, Mở khoá vân tay dưới màn hình\r\n',
'\r\n',
'Chặn cuộc gọi\r\n',
'Chặn tin nhắn\r\n',
'Mặt kính 2.5D\r\n',
'Màn hình luôn hiển thị AOD\r\n',
'\r\n',
'Radio	Có\r\n',
'Xem phim	3GP, MP4, AVI, WMV, DivX, Xvid\r\n',
'Nghe nhạc	Midi, MP3, WAV, WMA, AAC, OGG, FLAC\r\n',
'Thông tin khác\r\n',
'\r\n'), null, 0, 14490000, 50000, 0, '2019-12-24 00:10:00');






INSERT INTO product VALUES (11, 4, 1, null, 'Đồng hồ thông minh Huawei Watch GT2 46mm dây silicone', 4490000, '2019-12-24 12:00:00', '2020-01-06 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	AMOLED\r\n',
'Kích thước màn hình	1.39 inch\r\n',
'Độ phân giải	454 x 454 pixels\r\n',
'Chất liệu mặt	Kính cường lực\r\n',
'Đường kính mặt	46 mm\r\n',
'Cấu hình\r\n',
'CPU	Kirin A1\r\n',
'Bộ nhớ trong	2 GB\r\n',
'\r\n',
'\r\n',
'Cổng sạc	Đế sạc nam châm\r\n',
'Pin\r\n',
'Thời gian sử dụng pin	Khoảng 30 giờ khi sử dụng GPS, Khoảng 14 ngày\r\n',
'Thời gian sạc	Đang cập nhật\r\n',
'Dung lượng pin	Đang cập nhật\r\n',
'\r\n',
'\r\n',
'Hiển thị thông báo	Cuộc gọi, Nội dung tin nhắn, Zalo, Line, Viber\r\n',
'\r\n',
'\r\n',
'Camera	Không có\r\n',
'\r\n',
'Độ dài dây	Đang cập nhật\r\n',
'Độ rộng dây	2.2 cm\r\n',
'Chất liệu dây	Da\r\n',
'Dây có thể tháo rời	Có\r\n',
'Thông tin khác\r\n',
'Chất liệu khung viền	Thép không gỉ\r\n',
'Ngôn ngữ	Tiếng Anh, Tiếng Việt\r\n',
'Kích thước	Đang cập nhật\r\n',
'Trọng lượng	41 gram\r\n'), null, 0, 4490000, 50000, 0, '2019-12-24 00:11:00');





INSERT INTO product VALUES (12, 4, 1, null, 'Đồng hồ thông minh Xiaomi Amazfit Bip', 1400000, '2019-12-24 12:00:00', '2020-01-06 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	Transflective LCD\r\n',
'Kích thước màn hình	1.28 inch\r\n',
'Độ phân giải	176 x 176 pixels\r\n',
'Chất liệu mặt	Kính cường lực Gorilla Class 3\r\n',
'Đường kính mặt	31.1 mm\r\n',
'Cấu hình\r\n',
'CPU	1.2 GHz Dual Core - M200S\r\n',
'Bộ nhớ trong	Đang cập nhật\r\n',
'\r\n',
'\r\n',
'Cổng sạc	Đế sạc nam châm\r\n',
'Pin\r\n',
'Thời gian sử dụng pin	Khoảng 45 ngày, Khoảng 22 giờ khi sử dụng GPS\r\n',
'Thời gian sạc	Khoảng 2 giờ\r\n',
'Dung lượng pin	190 mAh\r\n',
'\r\n',
'\r\n',
'Hiển thị thông báo	Cuộc gọi, Nội dung tin nhắn, Tin nhắn, Zalo, Messenger (Facebook), Line, Viber\r\n',
'\r\n',
'\r\n',
'Camera	Không có\r\n',
'\r\n',
'Độ dài dây	Đang cập nhật\r\n',
'Độ rộng dây	2 cm\r\n',
'Chất liệu dây	Silicone\r\n',
'Dây có thể tháo rời	Có\r\n',
'Thông tin khác\r\n',
'Chất liệu khung viền	Nhựa\r\n',
'Ngôn ngữ	Tiếng Anh, Ứng dụng tiếng Anh, Ứng dụng tiếng Việt\r\n',
'Kích thước	Dài 3.2 cm - Rộng 3.1 cm - Dày 1.1 cm\r\n',
'Trọng lượng	32g\r\n'), null, 0, 1400000, 50000, 0, '2019-12-24 00:12:00');





INSERT INTO product VALUES (13, 4, 1, null, 'Đồng hồ thông minh Samsung Galaxy Watch Active R500', 4490000, '2019-12-24 12:00:00', '2020-01-07 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	AMOLED\r\n',
'Kích thước màn hình	1.1 inch\r\n',
'Độ phân giải	360 x 360 pixels\r\n',
'Chất liệu mặt	Kính cường lực Gorilla Class 3\r\n',
'Đường kính mặt	40 mm\r\n',
'Cấu hình\r\n',
'CPU	Exynos 9110\r\n',
'Bộ nhớ trong	4 GB\r\n',
'\r\n',
'\r\n',
'Cổng sạc	Đế sạc nam châm\r\n',
'Pin\r\n',
'Thời gian sử dụng pin	Khoảng 5 ngày\r\n',
'Thời gian sạc	Khoảng 2 giờ\r\n',
'Dung lượng pin	270 mAh\r\n',
'\r\n',
'\r\n',
'Hiển thị thông báo	Cuộc gọi, Nội dung tin nhắn, Tin nhắn, Zalo, Messenger (Facebook), Line, Viber\r\n',
'\r\n',
'\r\n',
'Camera	Không có\r\n',
'\r\n',
'Độ dài dây	22.6 cm\r\n',
'Độ rộng dây	2 cm\r\n',
'Chất liệu dây	Silicone\r\n',
'Dây có thể tháo rời	Có\r\n',
'Thông tin khác\r\n',
'Chất liệu khung viền	Nhôm\r\n',
'Ngôn ngữ	Tiếng Anh, Tiếng Việt\r\n',
'Kích thước	Dài 39.5 mm - Rộng 39.5 mm -Dày 10.5 mm\r\n',
'Trọng lượng	25 g\r\n'), null, 0, 4490000, 50000, 0, '2019-12-24 00:13:00');





INSERT INTO product VALUES (14, 4, 1, null, 'Apple Watch S5 44mm viền nhôm dây cao su', 11990000, '2019-12-24 12:00:00', '2020-01-07 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	OLED\r\n',
'Kích thước màn hình	1.78 inch\r\n',
'Độ phân giải	448 x 368 pixels\r\n',
'Chất liệu mặt	Ion-X strengthened glass\r\n',
'Đường kính mặt	44 mm\r\n',
'Cấu hình\r\n',
'CPU	Apple S5 64 bit\r\n',
'Bộ nhớ trong	32 GB\r\n',
'\r\n',
'\r\n',
'Cổng sạc	Đế sạc nam châm\r\n',
'Pin\r\n',
'Thời gian sử dụng pin	Khoảng 18 giờ\r\n',
'Thời gian sạc	Khoảng 2 giờ\r\n',
'Dung lượng pin	Đang cập nhật\r\n',
'\r\n',
'\r\n',
'Hiển thị thông báo	Cuộc gọi, Nội dung tin nhắn, Tin nhắn, Zalo, Messenger (Facebook), Line, Viber\r\n',
'\r\n',
'\r\n',
'Camera	Không có\r\n',
'\r\n',
'Độ dài dây	Đang cập nhật\r\n',
'Độ rộng dây	Đang cập nhật\r\n',
'Chất liệu dây	Silicone\r\n',
'Dây có thể tháo rời	Có\r\n',
'Thông tin khác\r\n',
'Chất liệu khung viền	Nhôm\r\n',
'Ngôn ngữ	Tiếng Anh, Tiếng Việt\r\n',
'Kích thước	Đường kính 44 mm - Dày 10.7 mm\r\n',
'Trọng lượng	36.7 gram\r\n'), null, 0, 11990000, 50000, 0, '2019-12-24 00:14:00');









INSERT INTO product VALUES (15, 4, 1, null, 'Vòng tay thông minh Zeblaze Plug C', 290000, '2019-12-24 12:00:00', '2020-01-08 12:00:00',
CONCAT('Màn hình\r\n',
'Công nghệ màn hình	Transflective LCD\r\n',
'Kích thước màn hình	0.85 inch\r\n',
'Độ phân giải	72 x 144 pixels\r\n',
'Chất liệu mặt	Kính cường lực\r\n',
'Đường kính mặt	18.8 mm\r\n',
'Cấu hình\r\n',
'CPU	Đang cập nhật\r\n',
'Bộ nhớ trong	Không có\r\n',
'\r\n',
'\r\n',
'\r\n',
'Pin\r\n',
'Thời gian sử dụng pin	Khoảng 7 ngày\r\n',
'Thời gian sạc	Khoảng 1.5 giờ\r\n',
'Dung lượng pin	90 mAh\r\n',
'\r\n',
'\r\n',
'Hiển thị thông báo	Cuộc gọi, Tin nhắn, Zalo, Line\r\n',
'\r\n',
'\r\n',
'Camera	\r\n',
'\r\n',
'Độ dài dây	19.5 cm\r\n',
'Độ rộng dây	1.5 cm\r\n',
'Chất liệu dây	Silicone\r\n',
'Dây có thể tháo rời	Có\r\n',
'Thông tin khác\r\n',
'Ngôn ngữ	Tiếng Anh, Ứng dụng tiếng Anh\r\n',
'Kích thước	45.6 mm - 18.8 mm - 12.5 mm\r\n',
'Trọng lượng	70 g\r\n'), 1000000, 1, 290000, 20000, 1, '2019-12-24 00:15:00');


COMMIT;

INSERT INTO image VALUES(1, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-1-3-org.jpg', '0c755b8a-7803-44db-8452-219a7990d1bd.jpg', 1);
INSERT INTO image VALUES(2, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-2-2-org.jpg', '24b9e97c-05a1-4ca7-a12c-0eedca8b88d4.jpg', 1);
INSERT INTO image VALUES(3, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-4-2-org.jpg', '6e2e1a7c-9e0f-4b56-a153-83acc3ba62b3.jpg', 1);
INSERT INTO image VALUES(4, '6e2e1a7c-9e0f-4b56-a153-83acc3ba62b3.jpg', '0f9fc348-8889-4fa8-af13-a3ba31289f28.jpg', 2);
INSERT INTO image VALUES(5, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-2-org.jpg', '8d248952-50e0-4f2f-a704-0fc166cdb895.jpg', 2);
INSERT INTO image VALUES(6, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-4-org.jpg', 'fcedd30a-d7f4-44ef-85fe-d2ca29e2044c.jpg', 2);
INSERT INTO image VALUES(7, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-1-org.jpg', 'bd238765-9b47-4fee-9c1f-e5eee775b883.jpg', 3);
INSERT INTO image VALUES(8, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-2-org.jpg', 'a50ff00b-8c6c-455e-beaa-f58cd84f3ec3.jpg', 3);
INSERT INTO image VALUES(9, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-4-org.jpg', '7595f124-2224-4fb2-ba15-3816a01ad753.jpg', 3);
INSERT INTO image VALUES(10, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-1-1-org.jpg', '03aba182-8eb6-4d07-90d9-dbe855236706.jpg', 4);
INSERT INTO image VALUES(11, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-2-org.jpg', '594fbf85-7d9a-4798-81cc-042e4613d835.jpg', 4);
INSERT INTO image VALUES(12, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-3-org.jpg', '83c951d8-bcf3-4730-835e-1797b5383ebd.jpg', 4);
INSERT INTO image VALUES(13, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-1-1-org.jpg', 'a799363d-04a4-40c9-b072-8c8c9ec7b0e3.jpg', 5);
INSERT INTO image VALUES(14, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-2-org.jpg', '0bb3b7b4-bc09-4049-996d-6b20e4af8130.jpg', 5);
INSERT INTO image VALUES(15, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-3-org.jpg', 'd7888a19-ecef-45b7-a60e-e66b0c965189.jpg', 5);
INSERT INTO image VALUES(16, 'oppo-a5-2020-den-1-org.jpg', '6c6aab33-7b81-4428-b436-f7cfad513696.jpg', 6);
INSERT INTO image VALUES(17, 'oppo-a5-2020-den-2-org.jpg', '898c47de-214e-4ce5-b98a-a037a301b494.jpg', 6);
INSERT INTO image VALUES(18, 'oppo-a5-2020-den-5-org.jpg', 'c3d5333d-387e-4f5a-8d06-0e7a368a3c13.jpg', 6);
INSERT INTO image VALUES(19, 'iphone-11-den-1-org.jpg', 'ec91ccd8-d31a-4181-b9fd-1a9dd760821a.jpg', 7);
INSERT INTO image VALUES(20, 'iphone-11-den-2-org.jpg', '27b91660-becc-427b-a020-e9fe8ba06348.jpg', 7);
INSERT INTO image VALUES(21, 'iphone-11-den-3-org.jpg', '5d83cb56-524d-4a5b-a5f6-0fb72671bc15.jpg', 7);
INSERT INTO image VALUES(22, 'samsung-galaxy-s10-plus-512gb-den-1-org.jpg', 'a4acf84e-d081-41a8-b2ae-52d43adf874e.jpg', 8);
INSERT INTO image VALUES(23, 'samsung-galaxy-s10-plus-512gb-den-2-org.jpg', '15711a0f-baf2-4094-be89-5d88b264bd09.jpg', 8);
INSERT INTO image VALUES(24, 'samsung-galaxy-s10-plus-512gb-den-3-org.jpg', '74f2a573-bfcc-42d9-ae3f-e488e2a246f0.jpg', 8);
INSERT INTO image VALUES(25, 'blackberry-key2-den-1-2-org.jpg', '6231f757-b6ca-48c4-bf36-78e3878f2552.jpg', 9);
INSERT INTO image VALUES(26, 'blackberry-key2-den-10-2-org.jpg', 'dc49b3e7-7067-446c-9d25-16e1bdb11ece.jpg', 9);
INSERT INTO image VALUES(27, 'blackberry-key2-den-2-2-org.jpg', '1eea00a4-b60c-4246-be29-64e3bfa31ee0.jpg', 9);
INSERT INTO image VALUES(28, 'xiaomi-mi-note-10-pro-den-1-org.jpg', 'bfc91d14-23e3-4538-8146-8f263d0109b3.jpg', 10);
INSERT INTO image VALUES(29, 'xiaomi-mi-note-10-pro-den-2-org.jpg', '6f6cb325-fb81-4c36-9e12-6f0bdb962725.jpg', 10);
INSERT INTO image VALUES(30, 'xiaomi-mi-note-10-pro-den-3-org.jpg', '488f1abf-b2c6-4d13-b449-7121c62dacf5.jpg', 10);
INSERT INTO image VALUES(31, 'watch-gt2-46mm-day-sillicone-den-1-org.jpg', '2fc54b9e-6655-40ef-bf24-b1e4c1998603.jpg', 11);
INSERT INTO image VALUES(32, 'watch-gt2-46mm-day-sillicone-den-2-org.jpg', '5e22a34c-9362-4848-82d1-9cc59388e967.jpg', 11);
INSERT INTO image VALUES(33, 'watch-gt2-46mm-day-sillicone-den-3-org.jpg', '794f3dd1-512f-47fe-bc62-3a09c123ff0e.jpg', 11);
INSERT INTO image VALUES(34, 'xiaomi-amazfit-bip-den-1-1-org.jpg', '20d8c00b-cc57-424e-bb64-248d1c243e05.jpg', 12);
INSERT INTO image VALUES(35, 'xiaomi-amazfit-bip-den-2-1-org.jpg', 'f0a7dbbf-2cc9-4349-b8b6-b8b37691008d.jpg', 12);
INSERT INTO image VALUES(36, 'xiaomi-amazfit-bip-den-3-1-org.jpg', 'd29f7707-9ef7-49bc-8520-30dc6fc51c71.jpg', 12);
INSERT INTO image VALUES(37, 'samsung-galaxy-watch-active-r500-bac-1-org.jpg', '9862446c-b39a-4157-b688-69101ba4e256.jpg', 13);
INSERT INTO image VALUES(38, 'samsung-galaxy-watch-active-r500-bac-2-org.jpg', 'b1b41b20-0fea-48d5-8399-a8da38b5e0e5.jpg', 13);
INSERT INTO image VALUES(39, 'samsung-galaxy-watch-active-r500-bac-4-org.jpg', '99b8af14-57dd-4e7a-8082-794cd7194127.jpg', 13);
INSERT INTO image VALUES(40, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-1-org.jpg', '1ef9b9e6-1ffa-405d-948b-2284f95667e2.jpg', 14);
INSERT INTO image VALUES(41, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-2-org.jpg', 'f30dcb46-f43c-4a5b-9013-349845a24a0c.jpg', 14);
INSERT INTO image VALUES(42, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-3-org.jpg', 'dd1833d8-f41b-4d39-8853-633ad1dc4f8e.jpg', 14);
INSERT INTO image VALUES(43, 'zeblaze-plug-c-den-1-1-org.jpg', '1ac28350-1c90-4d77-9397-bf122df11b65.jpg', 15);
INSERT INTO image VALUES(44, 'zeblaze-plug-c-den-1-org.jpg', '9626d897-64a5-4fc3-b797-813e5c2afea0.jpg', 15);
INSERT INTO image VALUES(45, 'zeblaze-plug-c-den-2-3-org.jpg', 'eacebb26-4e5e-404a-af8d-1d1e648333f8.jpg', 15);



COMMIT;



UPDATE `auction`.`product` SET `MAIN_IMAGE`='1' WHERE `ID`='1';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='4' WHERE `ID`='2';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='7' WHERE `ID`='3';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='10' WHERE `ID`='4';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='13' WHERE `ID`='5';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='16' WHERE `ID`='6';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='19' WHERE `ID`='7';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='22' WHERE `ID`='8';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='25' WHERE `ID`='9';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='28' WHERE `ID`='10';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='31' WHERE `ID`='11';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='34' WHERE `ID`='12';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='37' WHERE `ID`='13';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='40' WHERE `ID`='14';
UPDATE `auction`.`product` SET `MAIN_IMAGE`='43' WHERE `ID`='15';

COMMIT;










-- 31/12/2019


INSERT INTO product VALUES (16, 6, 1, null, 'Samsung Inverter 236 lít', 6290000, '2019-12-24 12:00:00', '2020-01-9 20:26:00', 'Đặc điểm nổi bật
Thiết kế sang trọng với sắc nâu thời thượng.
Cấp đông mềm Optimal Fresh Zone -1 độ C bảo quản thực phẩm trong ngày không cần rã đông.
Ngăn rau quả cân bằng độ ẩm Big Box giúp rau củ luôn tươi ngon, mọng nước.
Công nghệ Digital Inverter hiện đại không gây tiếng ồn, tiết kiệm điện năng.', null, 0, 6290000, 100000, 1, '2019-12-24 12:0:00');
INSERT INTO product VALUES (17, 6, 1, null, 'Panasonic Inverter 188 lít', 6190000, '2019-12-24 12:00:00', '2020-01-7 2:30:00', 'Đặc điểm nổi bật
Công nghệ làm lạnh Panorama độc quyền Panasonic giúp thực phẩm luôn tươi ngon.
Công nghệ kháng khuẩn khử mùi bằng tinh thể bạc tiêu diệt vi khuẩn và mùi hôi khó chịu.
Tủ lạnh tiết kiệm điện năng hiệu quả với công nghệ Inverter kết hợp cảm biến Econavi.
Hộc rau quả cung cấp độ ẩm cho rau quả tươi lâu trong thời gian dài.', null, 0, 6190000, 100000, 1, '2019-12-24 12:1:00');
INSERT INTO product VALUES (18, 6, 1, null, 'Samsung Inverter 319 lít', 12090000, '2019-12-24 12:00:00', '2020-01-2 22:50:00', 'Đặc điểm nổi bật
Thiết kế sang trọng, hiện đại với màu nâu thời thượng.
Hệ thống hai dàn lạnh riêng biệt chống lẫn mùi giữa 2 ngăn, duy trì độ ẩm cho thực phẩm.
Tính năng lấy nước ngoài tiện lợi.
Công nghệ Digital Inverter tiết kiệm điện năng, vận hành êm ái.
Hoạt động hiệu quả với 5 chế độ chuyển đổi theo nhu cầu.
Ngăn rau củ Big Box giữ ẩm tối ưu.', null, 0, 12090000, 100000, 1, '2019-12-24 12:2:00');
INSERT INTO product VALUES (19, 6, 1, null, 'Samsung Inverter 307 lít', 12490000, '2019-12-24 12:00:00', '2020-01-10 11:17:00', 'Đặc điểm nổi bật
Thiết kế ngăn đá dưới hiện đại, tiện lợi. Màu sắc đen nhám sang trọng, đẳng cấp.
Ngăn đông mềm Optimal Fresh Zone - 1 độ C giữ trọn vị tươi ngon sử dụng trong ngày.
Lấy nước bên ngoài tiện lợi, nhanh chóng, tiết kiệm điện.
Công nghệ biến tần kỹ thuật số Digital Inverter tiết kiệm điện hiệu quả.
Công nghệ làm lạnh dạng vòm làm lạnh đồng đều đến từng ngóc ngách.
Bộ lọc than hoạt tính lọc sạch không khí, loại bỏ mọi mùi hôi khó chịu bên trong tủ lạnh.', null, 0, 12490000, 100000, 1, '2019-12-24 12:3:00');
INSERT INTO product VALUES (20, 6, 1, null, 'Panasonic Inverter 366 lít', 16090000, '2019-12-24 12:00:00', '2020-01-14 4:37:00', 'Bảo vệ sức khoẻ gia đình và tiện lợi với khay lấy nước ngoài kháng khuẩn.
Hạn chế lẫn mùi thịt, cá với ngăn đựng thịt kháng khuẩn Ag Meat Case.
Giữ được rau củ có kích thuớc lớn tươi ngon với ngăn Wide Fresh Case.
Kháng khuẩn, khử mùi với tinh thể bạc Ag+.
Tiết kiêm điện, vận hành êm ái, bền bỉ nhờ công nghệ Inverter và cảm biến Econavi.
Mang hơi lạnh lan tỏa đều đến từng ngóc ngách trong tủ qua công nghệ làm lạnh Panorama.
Làm lạnh nhanh trái cây, nước uống nhờ ngăn Extra Cool Zone.', null, 0, 16090000, 100000, 1, '2019-12-24 12:4:00');
INSERT INTO product VALUES (21, 6, 1, null, 'Samsung Inverter 380 lít', 16790000, '2019-12-24 12:00:00', '2020-01-4 22:45:00', 'Đặc điểm nổi bật
Thiết kế sang trọng, hiện đại với màu đen inox huyền bí.
Công nghệ Digital Inverter tiết kiệm điện năng, vận hành êm ái.
Hệ thống hai dàn lạnh riêng biệt chống lẫn mùi giữa 2 ngăn, duy trì độ ẩm cho thực phẩm.
Hoạt động hiệu quả với 5 chế độ chuyển đổi theo nhu cầu.
Tính năng lấy nước ngoài và làm đá tự động tiện lợi.
Ngăn rau củ Big Box giữ ẩm tối ưu.', null, 0, 16790000, 100000, 1, '2019-12-24 12:5:00');
INSERT INTO product VALUES (22, 6, 1, null, 'Toshiba Inverter 194 lít', 6390000, '2019-12-24 12:00:00', '2020-01-13 20:55:00', 'Công nghệ Inverter tiết kiệm điện, máy chạy êm ái.
Ngăn Ultra Cooling Zone -1 độ trữ thịt cá ăn trong ngày không rã đông.
Không khí trong tủ luôn sạch, thông thoáng với hệ thống khử mùi và diệt khuẩn Ag+ Bio.
Duy trì độ lạnh ổn định giúp thực phẩm tươi ngon với hệ thống làm lạnh tuần hoàn.
Ngăn rau củ lớn giúp chứa nhiều loại rau củ, giữ ẩm tốt.
Khay đá xoắn tiện dụng, dễ dàng sử dụng.', null, 0, 6390000, 100000, 1, '2019-12-24 12:6:00');

INSERT INTO product VALUES (24, 3, 1, null, 'Macbook Air 2019 i5 1.6GHz/8GB/128GB', 27990000, '2019-12-24 12:00:00', '2020-01-11 16:0:00', 'Bộ xử lý

Công nghệ CPU	Intel Core i5 Coffee Lake
Loại CPU	Hãng không công bố
Tốc độ CPU	1.60 GHz
Tốc độ tối đa	Turbo Boost 3.6 GHz
Tốc độ Bus	

Bộ nhớ, RAM, Ổ cứng

RAM	8 GB
Loại RAM	DDR3
Tốc độ Bus RAM	2133 MHz
Hỗ trợ RAM tối đa	Không hỗ trợ nâng cấp
Ổ cứng	SSD: 128 GB

Màn hình

Kích thước màn hình	13.3 inch
Độ phân giải	Retina (2560 x 1600)
Công nghệ màn hình	Công nghệ IPS, LED Backlit
Màn hình cảm ứng	Không

Đồ họa và Âm thanh

Thiết kế card	Card đồ họa tích hợp
Card đồ họa	Intel UHD Graphics 617
Công nghệ âm thanh	3 microphones, Headphones, Loa kép (2 kênh)

Cổng kết nối & tính năng mở rộng

Cổng giao tiếp	2 x Thunderbolt 3 (USB-C)
Kết nối không dây	Bluetooth 4.2, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	Không
Ổ đĩa quang	Không
Webcam	FaceTime Camera
Đèn bàn phím	Có
Tính năng khác	Bảo mật vân tay, Hỗ trợ eGPU rời

PIN

Loại PIN	PIN liền
Thông tin Pin	Khoảng 10 giờ

Hệ điều hành

Hệ điều hành	Mac OS

Kích thước & trọng lượng

Kích thước	Dài 304.1 mm - Rộng 212.1 mm - Dày 4.1 đến 15.6 mm
Trọng lượng	1.25 kg
Chất liệu	Vỏ kim loại nguyên khối', null, 0, 27990000, 100000, 1, '2019-12-24 12:8:00');
INSERT INTO product VALUES (25, 3, 1, null, 'Lenovo Ideapad S145 15IWL i3 8145U/4GB/256GB/2GB', 10490000, '2019-12-24 12:00:00', '2020-01-10 8:54:00', 'Bộ xử lý

Công nghệ CPU	Intel Core i3 Coffee Lake
Loại CPU	8145U
Tốc độ CPU	2.10 GHz
Tốc độ tối đa	Turbo Boost 3.9 GHz
Tốc độ Bus	

Bộ nhớ, RAM, Ổ cứng

RAM	4 GB
Loại RAM	DDR4 (On board +1 khe)
Tốc độ Bus RAM	2400 MHz
Hỗ trợ RAM tối đa	12 GB
Ổ cứng	SSD 256GB NVMe PCIe, Hỗ trợ khe cắm HDD SATA

Màn hình

Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	Tấm nền TN, 60Hz, Anti-Glare
Màn hình cảm ứng	Không

Đồ họa và Âm thanh

Thiết kế card	Card đồ họa rời
Card đồ họa	NVIDIA GeForce MX110, 2GB
Công nghệ âm thanh	Dolby Home Theater

Cổng kết nối & tính năng mở rộng

Cổng giao tiếp	2 x USB 3.0, HDMI, USB 2.0
Kết nối không dây	Bluetooth 4.1, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	SD
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Không
Tính năng khác	Không

PIN

Loại PIN	PIN liền
Thông tin Pin	Li-Ion 2 cell

Hệ điều hành

Hệ điều hành	Windows 10 Home SL

Kích thước & trọng lượng

Kích thước	Dài 362 mm - Rộng 251.4 mm - Dày 19.9mm
Trọng lượng	1.73 kg
Chất liệu	Vỏ nhựa', null, 0, 10490000, 100000, 1, '2019-12-24 12:9:00');
INSERT INTO product VALUES (26, 3, 1, null, 'Acer Swift 3 SF315 52 38YQ i3 8130U/4GB/1TB/Win10', 11490000, '2019-12-24 12:00:00', '2020-01-1 10:34:00', 'Bộ xử lý

Công nghệ CPU	Intel Core i3 Coffee Lake
Loại CPU	8130U
Tốc độ CPU	2.20 GHz
Tốc độ tối đa	Turbo Boost 3.4 GHz
Tốc độ Bus	

Bộ nhớ, RAM, Ổ cứng

RAM	4 GB
Loại RAM	DDR4 (2 khe)
Tốc độ Bus RAM	2133 MHz
Hỗ trợ RAM tối đa	32 GB
Ổ cứng	HDD: 1 TB SATA3, Hỗ trợ khe cắm SSD M.2 PCIe

Màn hình

Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	Tấm nền IPS, Acer ComfyView
Màn hình cảm ứng	Không

Đồ họa và Âm thanh

Thiết kế card	Card đồ họa tích hợp
Card đồ họa	Intel® UHD Graphics 620
Công nghệ âm thanh	Acer TrueHarmony

Cổng kết nối & tính năng mở rộng

Cổng giao tiếp	2 x USB 3.0, HDMI, USB 2.0, USB Type-C
Kết nối không dây	Bluetooth v4.0, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	SD
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Có
Tính năng khác	Bảo mật vân tay

PIN

Loại PIN	PIN liền
Thông tin Pin	Li-Ion 4 cell

Hệ điều hành

Hệ điều hành	Windows 10 Home SL

Kích thước & trọng lượng

Kích thước	Dài 359 mm - Rộng 243 mm - Dày 16.9 mm
Trọng lượng	1.7 kg
Chất liệu	Vỏ kim loại', null, 0, 11490000, 100000, 1, '2019-12-24 12:10:00');
INSERT INTO product VALUES (27, 3, 1, null, 'Dell Vostro 5490 i5 10210U/8GB/256GB/Win10', 19490000, '2019-12-24 12:00:00', '2020-01-13 13:41:00', 'Bộ xử lý

Công nghệ CPU	Intel Core i5 Comet Lake
Loại CPU	10210U
Tốc độ CPU	1.60 GHz
Tốc độ tối đa	Turbo Boost 4.2 GHz
Tốc độ Bus	

Bộ nhớ, RAM, Ổ cứng

RAM	8 GB
Loại RAM	DDR4 (On board +1 khe)
Tốc độ Bus RAM	2666 MHz
Hỗ trợ RAM tối đa	24 GB
Ổ cứng	SSD 256GB NVMe PCIe, Hỗ trợ khe cắm HDD SATA

Màn hình

Kích thước màn hình	14 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	60Hz, Tấm nền TN, Anti-Glare
Màn hình cảm ứng	Không

Đồ họa và Âm thanh

Thiết kế card	Card đồ họa tích hợp
Card đồ họa	Intel UHD Graphics
Công nghệ âm thanh	Realtek High Definition Audio

Cổng kết nối & tính năng mở rộng

Cổng giao tiếp	2 x USB 3.1, HDMI, LAN (RJ45), USB 2.0, USB Type-C
Kết nối không dây	Bluetooth v5.0, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	Micro SD
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Có
Tính năng khác	Không

PIN

Loại PIN	PIN liền
Thông tin Pin	Li-Ion 3 cell

Hệ điều hành

Hệ điều hành	Windows 10 Home SL

Kích thước & trọng lượng

Kích thước	Dài 328 mm - Rộng 227.7 mm - Dày 18.3 mm
Trọng lượng	1.49 kg
Chất liệu	Vỏ nhựa - nắp lưng bằng kim loại', null, 0, 19490000, 100000, 1, '2019-12-24 12:11:00');
INSERT INTO product VALUES (28, 3, 1, null, 'MSI Gaming 15 GF63 9SC i7 9750H/8GB/256GB/4GB GTX1650/Win10', 25490000, '2019-12-24 12:00:00', '2020-01-1 6:55:00', 'Bộ xử lý

Công nghệ CPU	Intel Core i7 Coffee Lake
Loại CPU	9750H
Tốc độ CPU	2.60 GHz
Tốc độ tối đa	Turbo Boost 4.5 GHz
Tốc độ Bus	

Bộ nhớ, RAM, Ổ cứng

RAM	8 GB
Loại RAM	DDR4 (2 khe)
Tốc độ Bus RAM	2666 MHz
Hỗ trợ RAM tối đa	32 GB
Ổ cứng	SSD 256GB NVMe PCIe, Hỗ trợ khe cắm HDD SATA

Màn hình

Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	60Hz, Tấm nền IPS, Màn hình chống chói
Màn hình cảm ứng	Không

Đồ họa và Âm thanh

Thiết kế card	Card đồ họa rời
Card đồ họa	GeForce® GTX 1650 Max-Q Design
Công nghệ âm thanh	Nahimic 3

Cổng kết nối & tính năng mở rộng

Cổng giao tiếp	HDMI 2.0, 3 x USB 3.1, LAN (RJ45), USB Type-C
Kết nối không dây	Bluetooth v5.0, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	Không
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Có
Tính năng khác	Không

PIN

Loại PIN	PIN liền
Thông tin Pin	Li - Polymer 3 cell

Hệ điều hành

Hệ điều hành	Windows 10 Home SL

Kích thước & trọng lượng

Kích thước	Dài 359 mm - Rộng 254 mm - Dày 21.7 mm
Trọng lượng	1.86 kg
Chất liệu	Vỏ kim loại', null, 0, 25490000, 100000, 1, '2019-12-24 12:12:00');
INSERT INTO product VALUES (29, 3, 1, null, 'Laptop Acer Aspire A515 54G 51J3 i5 10210U/8GB/1TB SSD/2GB MX250/Win10 (NX.HN5SV.003)', 17990000, '2019-12-24 12:00:00', '2020-01-14 22:55:00', 'Bộ xử lý
Công nghệ CPU	Intel Core i5 Comet Lake
Loại CPU	10210U
Tốc độ CPU	1.60 GHz
Tốc độ tối đa	Turbo Boost 4.2 GHz
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	8 GB
Loại RAM	DDR4 (1 khe)
Tốc độ Bus RAM	2400 MHz
Hỗ trợ RAM tối đa	20 GB
Ổ cứng	SSD 1024 GB M.2 PCIe, Hỗ trợ khe cắm HDD SATA
Màn hình
Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	60Hz, Acer ComfyView
Màn hình cảm ứng	Không
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa rời
Card đồ họa	NVIDIA GeForce MX250 2GB
Công nghệ âm thanh	Realtek High Definition Audio
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	2 x USB 3.1, HDMI, LAN (RJ45), USB 2.0, USB Type-C
Kết nối không dây	Bluetooth 4.2, Wi-Fi 6 - 802.11ax
Khe đọc thẻ nhớ	Không
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Có
Tính năng khác	Không
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 3 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 363.4 mm - Rộng 250.5 mm - Dày 17.95 mm
Trọng lượng	1.7 kg
Chất liệu	Vỏ nhựa - nắp lưng bằng kim loại', null, 0, 17990000, 100000, 1, '2019-12-24 12:13:00');
INSERT INTO product VALUES (30, 3, 1, null, 'Laptop Lenovo ideapad C340 14IWL i3 8145U/8GB/256GB/Touch/Win10 (81N4003SVN)', 15190000, '2019-12-24 12:00:00', '2020-01-8 8:18:00', 'Bộ xử lý
Công nghệ CPU	Intel Core i3 Coffee Lake
Loại CPU	8145U
Tốc độ CPU	2.10 GHz
Tốc độ tối đa	Turbo Boost 3.9 GHz
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	8 GB
Loại RAM	DDR4 (1 khe)
Tốc độ Bus RAM	2133 MHz
Hỗ trợ RAM tối đa	32 GB
Ổ cứng	SSD 256GB NVMe PCIe
Màn hình
Kích thước màn hình	14 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	Tấm nền TN, 60Hz, LED Backlit
Màn hình cảm ứng	Có
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa tích hợp
Card đồ họa	Intel® UHD Graphics 620
Công nghệ âm thanh	Dolby Audio
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	2 x USB 3.1, HDMI, USB Type-C
Kết nối không dây	Wi-Fi 802.11 a/b/g/n, Bluetooth v5.0
Khe đọc thẻ nhớ	SD
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Có
Tính năng khác	Bảo mật vân tay
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 4 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 328 mm - Rộng 229 mm - Dày 17.9 mm
Trọng lượng	1.6 kg
Chất liệu	Vỏ nhựa', null, 0, 15190000, 100000, 1, '2019-12-24 12:14:00');
INSERT INTO product VALUES (31, 3, 1, null, 'Laptop Acer Swift 3 SF314 56 38UE i3 8145U/4GB/256GB/Win10 (NX.H4CSV.005)', 14490000, '2019-12-24 12:00:00', '2020-01-12 0:41:00', 'Bộ xử lý
Công nghệ CPU	Intel Core i3 Coffee Lake
Loại CPU	8145U
Tốc độ CPU	2.10 GHz
Tốc độ tối đa	Turbo Boost 3.9 GHz
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	4 GB
Loại RAM	DDR4 (On board +1 khe)
Tốc độ Bus RAM	2133 MHz
Hỗ trợ RAM tối đa	20 GB
Ổ cứng	SSD 256GB NVMe PCIe
Màn hình
Kích thước màn hình	14 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	Tấm nền IPS, Acer ComfyView
Màn hình cảm ứng	Không
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa tích hợp
Card đồ họa	Intel® UHD Graphics 620
Công nghệ âm thanh	Acer TrueHarmony
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	2 x USB 3.0, HDMI, USB 2.0, USB Type-C
Kết nối không dây	Wi-Fi 802.11 a/b/g/n, Bluetooth v4.0
Khe đọc thẻ nhớ	SD
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Có
Tính năng khác	Bảo mật vân tay
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 4 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 323 mm - Rộng 228 mm - Dày 17.95 mm
Trọng lượng	1.45 kg
Chất liệu	Vỏ kim loại', null, 0, 14490000, 100000, 1, '2019-12-24 12:15:00');
INSERT INTO product VALUES (32, 3, 1, null, 'Laptop Acer Aspire A515 53 5112 i5 8265U/4GB+16GB/1TB/Win10 (NX.H6DSV.002)', 14990000, '2019-12-24 12:00:00', '2020-01-7 2:36:00', 'Bộ xử lý
Công nghệ CPU	Intel Core i5 Coffee Lake
Loại CPU	8265U
Tốc độ CPU	1.60 GHz
Tốc độ tối đa	Turbo Boost 3.9 GHz
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	4 GB
Loại RAM	DDR4 (On board +1 khe)
Tốc độ Bus RAM	2133 MHz
Hỗ trợ RAM tối đa	20 GB
Ổ cứng	HDD: 1 TB SATA3, Intel Optane 16GB
Màn hình
Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	Acer ComfyView
Màn hình cảm ứng	Không
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa tích hợp
Card đồ họa	Intel® UHD Graphics 620
Công nghệ âm thanh	Stereo, Mini Jack x 1
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	2 x USB 3.0, HDMI, LAN (RJ45), USB Type-C
Kết nối không dây	Bluetooth 4.2, Wi-Fi 802.11 a/b/g/n
Khe đọc thẻ nhớ	SD
Ổ đĩa quang	Có (đọc, ghi dữ liệu)
Webcam	HD webcam
Đèn bàn phím	Không
Tính năng khác	Không
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 3 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 363.4 mm - Rộng 257.5 mm - Dày 22.45 mm
Trọng lượng	2.0 kg
Chất liệu	Vỏ nhựa', null, 0, 14990000, 100000, 1, '2019-12-24 12:16:00');
INSERT INTO product VALUES (33, 3, 1, null, 'Laptop Dell Inspiron 5584 i5 8265U/8GB/1TB/Win10 (CXGR01)', 18990000, '2019-12-24 12:00:00', '2020-01-15 19:49:00', 'Bộ xử lý
Công nghệ CPU	Intel Core i5 Coffee Lake
Loại CPU	8265U
Tốc độ CPU	1.60 GHz
Tốc độ tối đa	Turbo Boost 3.9 GHz
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	8 GB
Loại RAM	DDR4 (2 khe)
Tốc độ Bus RAM	2666 MHz
Hỗ trợ RAM tối đa	32 GB
Ổ cứng	HDD: 1 TB SATA3, Hỗ trợ khe cắm SSD M.2 PCIe
Màn hình
Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	60Hz, LED Backlit, Anti-Glare
Màn hình cảm ứng	Không
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa tích hợp
Card đồ họa	Intel® UHD Graphics 620
Công nghệ âm thanh	Waves MaxxAudio
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	2 x USB 3.1, HDMI, LAN (RJ45), USB 2.0
Kết nối không dây	Bluetooth 4.1, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	SD
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Có
Tính năng khác	Bảo mật vân tay
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 3 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 365 mm - Rộng 250 mm - Dày 22 mm
Trọng lượng	2.025 kg
Chất liệu	Vỏ nhựa', null, 0, 18990000, 100000, 1, '2019-12-24 12:17:00');
INSERT INTO product VALUES (34, 3, 1, null, 'Laptop Dell Inspiron 3579 i5 8300H/8GB/1TB+128GB/4GB GTX1050Ti/Win10 (G5I5423W)', 24890000, '2019-12-24 12:00:00', '2020-01-9 11:20:00', 'Bộ xử lý
Công nghệ CPU	Intel Core i5 Coffee Lake
Loại CPU	8300H
Tốc độ CPU	2.30 GHz
Tốc độ tối đa	Turbo Boost 4.0 GHz
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	8 GB
Loại RAM	DDR4 (2 khe)
Tốc độ Bus RAM	2666 MHz
Hỗ trợ RAM tối đa	32 GB
Ổ cứng	SSD 128GB M2 PCIe, HDD: 1 TB SATA3
Màn hình
Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	60Hz, Tấm nền IPS, Anti-Glare, LED Backlit
Màn hình cảm ứng	Không
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa rời
Card đồ họa	NVIDIA GeForce GTX 1050Ti, 4GB
Công nghệ âm thanh	Waves MaxxAudio
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	HDMI 1.4, 2 x USB 3.1, USB 2.0
Kết nối không dây	Bluetooth v5.0, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	SD
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Có
Tính năng khác	Bảo mật vân tay
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 4 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 380 mm - Rộng 258 mm - Dày 23 mm
Trọng lượng	2.35 kg
Chất liệu	Vỏ nhựa', null, 0, 24890000, 100000, 1, '2019-12-24 12:18:00');

INSERT INTO product VALUES (36, 3, 1, null, 'Laptop Acer Aspire A315 42 R8PX R3 3200U/8GB/256GB/Win10 (NX.HF9SV.00A)', 10990000, '2019-12-24 12:00:00', '2020-01-13 23:6:00', 'Bộ xử lý
Công nghệ CPU	AMD Ryzen 3
Loại CPU	3200U
Tốc độ CPU	2.60 GHz
Tốc độ tối đa	Turbo Boost 3.5 GHz
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	8 GB
Loại RAM	DDR4 (2 khe)
Tốc độ Bus RAM	2133 MHz
Hỗ trợ RAM tối đa	16 GB
Ổ cứng	SSD 256GB NVMe PCIe, Hỗ trợ khe cắm HDD SATA
Màn hình
Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	60Hz, Acer ComfyView
Màn hình cảm ứng	Không
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa tích hợp
Card đồ họa	AMD Radeon™ Vega 3 Graphics
Công nghệ âm thanh	Loa kép (2 kênh)
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	2 x USB 2.0, USB 3.1, HDMI, LAN (RJ45)
Kết nối không dây	Bluetooth 4.2, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	Không
Ổ đĩa quang	Không
Webcam	HD webcam
Đèn bàn phím	Không
Tính năng khác	Không
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 2 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 363.4 mm - Rộng 247.5 mm - Dày 19.9 mm
Trọng lượng	1.7kg
Chất liệu	Vỏ nhựa', null, 0, 10990000, 100000, 1, '2019-12-24 12:20:00');
INSERT INTO product VALUES (37, 3, 1, null, 'Laptop Dell Inspiron 3593 i7 1065G7/8GB/512GB/2GB MX230/Win10 (70197459)', 22390000, '2019-12-24 12:00:00', '2020-01-5 14:15:00', 'Bộ xử lý
Công nghệ CPU	Intel Core i7 Ice Lake
Loại CPU	1065G7
Tốc độ CPU	1.30 GHz
Tốc độ tối đa	Turbo Boost 3.9 GHz
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	8 GB
Loại RAM	DDR4 (2 khe)
Tốc độ Bus RAM	2666 MHz
Hỗ trợ RAM tối đa	16 GB
Ổ cứng	SSD 512 GB M.2 PCIe, Hỗ trợ khe cắm HDD SATA
Màn hình
Kích thước màn hình	15.6 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	60Hz, Anti-Glare, LED Backlit
Màn hình cảm ứng	Không
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa rời
Card đồ họa	NVIDIA GeForce MX230 2GB
Công nghệ âm thanh	Realtek High Definition Audio
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	2 x USB 3.1, HDMI, LAN (RJ45), USB 2.0, USB Type-C
Kết nối không dây	Bluetooth, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	SD
Ổ đĩa quang	Có (đọc, ghi dữ liệu)
Webcam	HD webcam
Đèn bàn phím	Không
Tính năng khác	Không
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 3 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 380 mm - Rộng 258 mm - Dày 22.7 mm
Trọng lượng	2.28 kg
Chất liệu	Vỏ nhựa', null, 0, 22390000, 100000, 1, '2019-12-24 12:21:00');
INSERT INTO product VALUES (38, 3, 1, null, 'Laptop Acer Spin 3 SP314 51 39WK i3 7130U/4GB/500GB/Win10 (NX.GUWSV.001)', 11990000, '2019-12-24 12:00:00', '2020-01-8 11:11:00', 'Bộ xử lý
Công nghệ CPU	Intel Core i3 Kabylake
Loại CPU	7130U
Tốc độ CPU	2.70 GHz
Tốc độ tối đa	Không
Tốc độ Bus	
Bộ nhớ, RAM, Ổ cứng
RAM	4 GB
Loại RAM	DDR4 (On board)
Tốc độ Bus RAM	2133 MHz
Hỗ trợ RAM tối đa	Không hỗ trợ nâng cấp
Ổ cứng	HDD: 500 GB, Hỗ trợ khe cắm SSD M.2 PCIe
Màn hình
Kích thước màn hình	14 inch
Độ phân giải	Full HD (1920 x 1080)
Công nghệ màn hình	Tấm nền IPS, Màn hình Wide View, Viền màn hình mỏng, LED Backlit, Acer ComfyView, Lật, Xoay 360 độ
Màn hình cảm ứng	Có
Đồ họa và Âm thanh
Thiết kế card	Card đồ họa tích hợp
Card đồ họa	Intel® HD Graphics 620
Công nghệ âm thanh	Acer TrueHarmony, Loa kép (2 kênh), Combo Microphone & Headphone
Cổng kết nối & tính năng mở rộng
Cổng giao tiếp	2 x USB 3.0, HDMI, USB 2.0
Kết nối không dây	Bluetooth 4.1, Wi-Fi 802.11 a/b/g/n/ac
Khe đọc thẻ nhớ	SD, SDHC, SDXC
Ổ đĩa quang	Không
Webcam	1 MP, HD webcam
Đèn bàn phím	Không
Tính năng khác	USB Charge, 2x2 Wi-Fi antenna, Multi TouchPad, Micro kép
PIN
Loại PIN	PIN liền
Thông tin Pin	Li-Ion 3 cell
Hệ điều hành
Hệ điều hành	Windows 10 Home SL
Kích thước & trọng lượng
Kích thước	Dài 335 mm - Rộng 230 mm - Dày 20.8 mm
Trọng lượng	1.7 kg
Chất liệu	Vỏ nhựa', null, 0, 11990000, 100000, 1, '2019-12-24 12:22:00');

INSERT INTO product VALUES (40, 2, 1, null, 'oppo-a5-2010', 4290000, '2019-12-24 12:00:00', '2020-01-1 9:9:00', 'Màn hình

Công nghệ màn hình	TFT
Độ phân giải	HD+ (720 x 1600 Pixels)
Màn hình rộng	6.5"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 3

Camera sau

Độ phân giải	Chính 12 MP & Phụ 8 MP, 2 MP, 2 MP
Quay phim	Quay phim HD 720p@30fps, Quay phim FullHD 1080p@30fps, Quay phim 4K 2160p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Làm đẹp, Góc siêu rộng (Ultrawide), Quay chậm (Slow Motion), Trôi nhanh thời gian (Time Lapse), Ban đêm (Night Mode), A.I Camera, Xoá phông, Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Chuyên nghiệp (Pro)

Camera trước

Độ phân giải	8 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Xoá phông, Làm đẹp (Selfie A.I Beauty), Flash màn hình, Toàn cảnh (Panorama), Quay video HD, Chụp bằng cử chỉ, Nhận diện khuôn mặt, Làm đẹp (Beautify), Quay video Full HD, Tự động lấy nét (AF), HDR

Hệ điều hành - CPU

Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Snapdragon 665 8 nhân
Tốc độ CPU	4 nhân 2.0 GHz & 4 nhân 1.8 GHz
Chip đồ họa (GPU)	Adreno 610

Bộ nhớ & Lưu trữ

RAM	4 GB
Bộ nhớ trong	128 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 104 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 256 GB

Kết nối

Mạng di động	3G, 4G LTE Cat 13
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 a/b/g/n/ac, DLNA, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	LE, A2DP, v5.0
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	OTG

Thiết kế & Trọng lượng

Thiết kế	Nguyên khối
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 163.6 mm - Ngang 75.6 mm - Dày 9.1 mm
Trọng lượng	195 g

Thông tin pin & Sạc

Dung lượng pin	5000 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin

Tiện ích

Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Khoá ứng dụng
Nhân bản ứng dụng
Không gian trẻ em
Đa cửa sổ (chia đôi màn hình)
Không gian trò chơi
Mặt kính 2.5D
Chặn tin nhắn
Báo rung khi kết nối cuộc gọi
Chặn cuộc gọi
Đèn pin
Dolby Audio™
Trợ lý ảo Google Assistant
Ghi âm	Có
Radio	Có
Xem phim	MP4, AVI, WMV, H.264(MPEG4-AVC)
Nghe nhạc	AMR, MP3, WAV, eAAC+

Thông tin khác

Thời điểm ra mắt	10/2019', null, 0, 4290000, 100000, 1, '2019-12-24 12:24:00');
INSERT INTO product VALUES (41, 2, 1, null, 'iPhone 11', 23990000, '2019-12-24 12:00:00', '2020-01-14 10:32:00', 'Màn hình

Công nghệ màn hình	IPS LCD
Độ phân giải	828 x 1792 Pixels
Màn hình rộng	6.1"
Mặt kính cảm ứng	Kính cường lực oleophobic (ion cường lực)

Camera sau

Độ phân giải	Chính 12 MP & Phụ 12 MP
Quay phim	Quay phim HD 720p@30fps, Quay phim FullHD 1080p@30fps, Quay phim FullHD 1080p@60fps, Quay phim FullHD 1080p@120fps, Quay phim FullHD 1080p@240fps, Quay phim 4K 2160p@24fps, Quay phim 4K 2160p@30fps, Quay phim 4K 2160p@60fps
Đèn Flash	4 đèn LED (2 tông màu)
Chụp ảnh nâng cao	Ban đêm (Night Mode), Trôi nhanh thời gian (Time Lapse), Quay chậm (Slow Motion), Xoá phông, Zoom quang học, Góc rộng (Wide), Góc siêu rộng (Ultrawide), Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama)

Camera trước

Độ phân giải	12 MP
Videocall	Có
Thông tin khác	Xoá phông, Quay phim 4K, Nhãn dán (AR Stickers), Retina Flash, Quay video HD, Nhận diện khuôn mặt, Quay video Full HD, Tự động lấy nét (AF), HDR, Quay chậm (Slow Motion)

Hệ điều hành - CPU

Hệ điều hành	iOS 13
Chipset (hãng SX CPU)	Apple A13 Bionic 6 nhân
Tốc độ CPU	2 nhân 2.65 GHz & 4 nhân 1.8 GHz
Chip đồ họa (GPU)	Apple GPU 4 nhân
Bộ nhớ & Lưu trữ
RAM	4 GB
Bộ nhớ trong	128 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 123 GB
Thẻ nhớ ngoài	Không

Kết nối

Mạng di động	Hỗ trợ 4G
SIM	1 eSIM & 1 Nano SIM
Wifi	Dual-band, Wi-Fi 802.11 a/b/g/n/ac/ax, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	LE, A2DP, v5.0
Cổng kết nối/sạc	Lightning
Jack tai nghe	Lightning
Kết nối khác	NFC, OTG

Thiết kế & Trọng lượng

Thiết kế	Nguyên khối
Chất liệu	Khung nhôm & Mặt lưng kính cường lực
Kích thước	Dài 150.9 mm - Ngang 75.7 mm - Dày 8.3 mm
Trọng lượng	194 g

Thông tin pin & Sạc

Dung lượng pin	3110 mAh
Loại pin	Pin chuẩn Li-Ion
Công nghệ pin	Tiết kiệm pin, Sạc pin nhanh, Sạc pin không dây

Tiện ích

Bảo mật nâng cao	Mở khoá khuôn mặt Face ID
Tính năng đặc biệt	Đèn pin
Dolby Audio™
Chuẩn Kháng nước, Chuẩn kháng bụi
Sạc pin không dây
Sạc pin nhanh
Apple Pay
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Không
Xem phim	H.264(MPEG4-AVC)
Nghe nhạc	Lossless, MP3, AAC, FLAC

Thông tin khác

Thời điểm ra mắt	11/2019', null, 0, 23990000, 100000, 1, '2019-12-24 12:25:00');
INSERT INTO product VALUES (42, 2, 1, null, 'Samsung Galaxy S10+', 28990000, '2019-12-24 12:00:00', '2020-01-13 23:55:00', 'Màn hình

Công nghệ màn hình	Dynamic AMOLED
Độ phân giải	2K+ (1440 x 3040 Pixels)
Màn hình rộng	6.4"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 6

Camera sau

Độ phân giải	Chính 12 MP & Phụ 12 MP, 16 MP
Quay phim	Quay phim siêu chậm 960 fps, Quay phim FullHD 1080p@240fps, Quay phim 4K 2160p@60fps
Đèn Flash	Có
Chụp ảnh nâng cao	Quay siêu chậm (Super Slow Motion), Điều chỉnh khẩu độ, Lấy nét theo pha (PDAF), A.I Camera, Ban đêm (Night Mode), Trôi nhanh thời gian (Time Lapse), Quay chậm (Slow Motion), Xoá phông, Zoom quang học, Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Chống rung quang học (OIS), Làm đẹp (Beautify), Chuyên nghiệp (Pro)

Camera trước

Độ phân giải	Chính 10 MP & Phụ 8 MP
Videocall	Có
Thông tin khác	Làm đẹp (Beautify), Quay video Full HD, Tự động lấy nét (AF), HDR, Xoá phông, Quay phim 4K, Nhãn dán (AR Stickers), Flash màn hình, Chụp bằng cử chỉ, Nhận diện khuôn mặt

Hệ điều hành - CPU

Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Exynos 9820 8 nhân
Tốc độ CPU	2 nhân 2.7 GHz, 2 nhân 2.3 GHz & 4 nhân 1.9 GHz
Chip đồ họa (GPU)	Mali-G76 MP12

Bộ nhớ & Lưu trữ

RAM	8 GB
Bộ nhớ trong	512 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 480 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 512 GB

Kết nối

Mạng di động	Hỗ trợ 4G
SIM	2 SIM Nano (SIM 2 chung khe thẻ nhớ)
Wifi	Dual-band, Wi-Fi 802.11 a/b/g/n/ac/ax, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	A2DP, LE, apt-X, v5.0
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	NFC, OTG

Thiết kế & Trọng lượng

Thiết kế	Nguyên khối
Chất liệu	Khung kim loại & Mặt lưng kính cường lực
Kích thước	Dài 157.6 mm - Ngang 74.1 mm - Dày 7.8 mm
Trọng lượng	175 g
Thông tin pin & Sạc
Dung lượng pin	4100 mAh
Loại pin	Pin chuẩn Li-Ion
Công nghệ pin	Tiết kiệm pin, Siêu tiết kiệm pin, Sạc pin nhanh, Sạc pin không dây, Sạc ngược không dây

Tiện ích

Bảo mật nâng cao	Mở khoá khuôn mặt, Mở khoá vân tay dưới màn hình
Tính năng đặc biệt	Thu nhỏ màn hình sử dụng một tay
Samsung Pay
Nhân bản ứng dụng
Samsung DeX
Dolby Audio™
Trợ lý ảo Samsung Bixby
Màn hình luôn hiển thị AOD
Chặn tin nhắn
Ghi âm cuộc gọi
Chặn cuộc gọi
Sạc pin nhanh
Chạm 2 lần sáng màn hình
Chuẩn Kháng nước, Chuẩn kháng bụi
Đèn pin
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Không
Xem phim	H.265, 3GP, MP4, AVI, WMV, H.264(MPEG4-AVC), DivX, WMV9, Xvid
Nghe nhạc	Lossless, Midi, MP3, WAV, WMA, AAC++, eAAC+, OGG, AC3, FLAC

Thông tin khác

Thời điểm ra mắt	02/2019', null, 0, 28990000, 100000, 1, '2019-12-24 12:26:00');
INSERT INTO product VALUES (43, 2, 1, null, 'BlackBerry Key 2', 15990000, '2019-12-24 12:00:00', '2020-01-1 6:8:00', 'Màn hình

Công nghệ màn hình	IPS LCD
Độ phân giải	1080 x 1620 Pixels
Màn hình rộng	4.5"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 3

Camera sau

Độ phân giải	Chính 12 MP & Phụ 12 MP
Quay phim	Quay phim 4K 2160p@30fps
Đèn Flash	Đèn LED 2 tông màu
Chụp ảnh nâng cao	Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama)

Camera trước

Độ phân giải	8 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Tự động lấy nét (AF), Quay video Full HD, Nhận diện khuôn mặt
Hệ điều hành - CPU
Hệ điều hành	Android 8.1 (Oreo)
Chipset (hãng SX CPU)	Snapdragon 660 8 nhân
Tốc độ CPU	4 nhân 2.2 GHz & 4 nhân 1.8 GHz
Chip đồ họa (GPU)	Adreno 512

Bộ nhớ & Lưu trữ

RAM	6 GB
Bộ nhớ trong	64 GB
Bộ nhớ còn lại (khả dụng)	Đang cập nhật
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 256 GB

Kết nối

Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	LE, v5.0
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	OTG

Thiết kế & Trọng lượng

Thiết kế	Nguyên khối
Chất liệu	Khung kim loại & Mặt lưng kính cường lực
Kích thước	Dài 151.4 mm - Ngang 71.8 mm - Dày 8.5 mm
Trọng lượng	168 g

Thông tin pin & Sạc

Dung lượng pin	3500 mAh
Loại pin	Pin chuẩn Li-Ion
Công nghệ pin	Tiết kiệm pin, Sạc nhanh Quick Charge 3.0
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay
Tính năng đặc biệt	Sạc pin nhanh
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Có
Xem phim	3GP, AVI, H.264(MPEG4-AVC), DivX
Nghe nhạc	MP3, WAV, AAC, OGG, FLAC

Thông tin khác

Thời điểm ra mắt	11/2018', null, 0, 15990000, 100000, 1, '2019-12-24 12:27:00');
INSERT INTO product VALUES (44, 2, 1, null, 'Xiaomi Mi Note 10 Pro', 14490000, '2019-12-24 12:00:00', '2020-01-13 21:43:00', 'Màn hình

Công nghệ màn hình	AMOLED
Độ phân giải	Full HD+ (1080 x 2340 Pixels)
Màn hình rộng	6.47"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 5

Camera sau

Độ phân giải	Chính 108 MP & Phụ 20 MP, 12 MP, 5 MP, 2 MP
Quay phim	Quay phim HD 720p@960fps, Quay phim FullHD 1080p@30fps, Quay phim FullHD 1080p@60fps, Quay phim FullHD 1080p@120fps, Quay phim FullHD 1080p@240fps, Quay phim 4K 2160p@30fps
Đèn Flash	4 đèn LED (2 tông màu)
Chụp ảnh nâng cao	Quay siêu chậm (Super Slow Motion), Lấy nét theo pha (PDAF), A.I Camera, Siêu độ phân giải, Ban đêm (Night Mode), Trôi nhanh thời gian (Time Lapse), Quay chậm (Slow Motion), Xoá phông, Zoom quang học, Góc siêu rộng (Ultrawide), Lấy nét bằng laser, Làm đẹp, Góc rộng (Wide), Siêu cận (Macro), Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Chống rung quang học (OIS), Làm đẹp (Beautify), Chuyên nghiệp (Pro)

Camera trước

Độ phân giải	32 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Tự động lấy nét (AF), Xoá phông, Quay video HD, HDR, Quay video Full HD, Làm đẹp (Beautify), Nhận diện khuôn mặt

Hệ điều hành - CPU

Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Snapdragon 730G 8 nhân
Tốc độ CPU	2 nhân 2.2 GHz & 6 nhân 1.8 GHz
Chip đồ họa (GPU)	Adreno 618

Bộ nhớ & Lưu trữ

RAM	8 GB
Bộ nhớ trong	256 GB
Bộ nhớ còn lại (khả dụng)	Đang cập nhật
Thẻ nhớ ngoài	Không

Kết nối

Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	apt-X, A2DP, LE, v5.0
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	NFC, OTG, Hồng Ngoại

Thiết kế & Trọng lượng

Thiết kế	Nguyên khối
Chất liệu	Khung kim loại & Mặt lưng kính cường lực
Kích thước	Dài 157.8 mm - Ngang 74.2 mm - Dày 9.67 mm
Trọng lượng	208 g
Thông tin pin & Sạc
Dung lượng pin	5260 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin, Siêu tiết kiệm pin, Sạc pin nhanh

Tiện ích

Bảo mật nâng cao	Mở khoá khuôn mặt, Mở khoá vân tay dưới màn hình
Tính năng đặc biệt	Đèn pin
Chặn cuộc gọi
Chặn tin nhắn
Mặt kính 2.5D
Màn hình luôn hiển thị AOD
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Có
Xem phim	3GP, MP4, AVI, WMV, DivX, Xvid
Nghe nhạc	Midi, MP3, WAV, WMA, AAC, OGG, FLAC

Thông tin khác

Thời điểm ra mắt	Đang cập nhật', null, 0, 14490000, 100000, 1, '2019-12-24 12:28:00');
INSERT INTO product VALUES (45, 2, 1, null, 'Điện thoại Xiaomi Redmi 7 (3GB/32GB)', 3290000, '2019-12-24 12:00:00', '2020-01-9 12:24:00', 'Màn hình
Công nghệ màn hình	IPS LCD
Độ phân giải	HD+ (720 x 1520 Pixels)
Màn hình rộng	6.26"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 5
Camera sau
Độ phân giải	Chính 12 MP & Phụ 2 MP
Quay phim	Quay phim FullHD 1080p@30fps, Quay phim FullHD 1080p@60fps
Đèn Flash	Có
Chụp ảnh nâng cao	Xoá phông, Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR
Camera trước
Độ phân giải	8 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Quay video HD, Quay video Full HD, Tự động lấy nét (AF)
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Snapdragon 632 8 nhân
Tốc độ CPU	1.8 GHz
Chip đồ họa (GPU)	Adreno 506
Bộ nhớ & Lưu trữ
RAM	3 GB
Bộ nhớ trong	32 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 22 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 512 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 b/g/n, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	A2DP, LE, v4.2
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Kết nối khác	Hồng Ngoại
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 158.7 mm - Ngang 75.6 mm - Dày 8.5 mm
Trọng lượng	180 g
Thông tin pin & Sạc
Dung lượng pin	4000 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Chặn tin nhắn
Chặn cuộc gọi
Đèn pin
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Có
Xem phim	H.265, MP4, H.264(MPEG4-AVC)
Nghe nhạc	MP3, WAV, AAC, FLAC
Thông tin khác
Thời điểm ra mắt	03/2019', null, 0, 3290000, 100000, 1, '2019-12-24 12:29:00');
INSERT INTO product VALUES (46, 2, 1, null, 'Điện thoại Samsung Galaxy A10s', 3390000, '2019-12-24 12:00:00', '2020-01-13 7:38:00', 'Màn hình
Công nghệ màn hình	IPS TFT
Độ phân giải	HD+ (720 x 1520 Pixels)
Màn hình rộng	6.2"
Mặt kính cảm ứng	Mặt kính cong 2.5D
Camera sau
Độ phân giải	Chính 13 MP & Phụ 2 MP
Quay phim	Quay phim HD 720p@30fps, Quay phim FullHD 1080p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Làm đẹp, Nhãn dán (AR Stickers), Xoá phông, Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Làm đẹp (Beautify), Chuyên nghiệp (Pro)
Camera trước
Độ phân giải	8 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Tự động lấy nét (AF), Xoá phông, Nhãn dán (AR Stickers), Quay video HD, Chụp bằng cử chỉ, Nhận diện khuôn mặt, Làm đẹp (Beautify), Quay video Full HD
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	MediaTek MT6762 8 nhân (Helio P22)
Tốc độ CPU	4 nhân 2.0 GHz & 4 nhân 1.5 GHz
Chip đồ họa (GPU)	PowerVR GE8320
Bộ nhớ & Lưu trữ
RAM	2 GB
Bộ nhớ trong	32 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 22 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 512 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 b/g/n, Wi-Fi Direct, Wi-Fi hotspot
GPS	A-GPS, GLONASS
Bluetooth	A2DP, LE, v5.0
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Kết nối khác	OTG
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 156.9 mm - Ngang 75.8 mm - Dày 7.8 mm
Trọng lượng	168 g
Thông tin pin & Sạc
Dung lượng pin	4000 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin, Siêu tiết kiệm pin
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Mặt kính 2.5D
Đèn pin
Dolby Audio™
Ghi âm cuộc gọi
Chặn cuộc gọi
Nhân bản ứng dụng
Chặn tin nhắn
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Có
Xem phim	3GP, MP4, AVI, WMV
Nghe nhạc	AMR, Midi, MP3, WAV, WMA, AAC, OGG, FLAC
Thông tin khác
Thời điểm ra mắt	08/2019', null, 0, 3390000, 100000, 1, '2019-12-24 12:30:00');
INSERT INTO product VALUES (47, 2, 1, null, 'Điện thoại Vsmart Live (6GB/64GB)', 3790000, '2019-12-24 12:00:00', '2020-01-1 0:12:00', 'Màn hình
Công nghệ màn hình	AMOLED
Độ phân giải	Full HD+ (1080 x 2232 Pixels)
Màn hình rộng	6.2"
Mặt kính cảm ứng	Mặt kính cong 2.5D
Camera sau
Độ phân giải	Chính 48 MP & Phụ 8 MP, 5 MP
Quay phim	Quay phim FullHD 1080p@120fps, Quay phim 4K 2160p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Góc siêu rộng (Ultrawide), Ban đêm (Night Mode), A.I Camera, Xoá phông
Camera trước
Độ phân giải	20 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Tự động lấy nét (AF), Làm đẹp (Beautify), Nhận diện khuôn mặt, Làm đẹp (Selfie A.I Beauty)
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Snapdragon 675 8 nhân
Tốc độ CPU	2 nhân 2.0 GHz & 6 nhân 1.8 GHz
Chip đồ họa (GPU)	Adreno 612
Bộ nhớ & Lưu trữ
RAM	6 GB
Bộ nhớ trong	64 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 53 GB
Thẻ nhớ ngoài	Không
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 a/b/g/n/ac, Wi-Fi hotspot
GPS	A-GPS, GLONASS
Bluetooth	LE, A2DP, v5.0
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	OTG
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung nhựa, kim loại & Mặt lưng nhựa
Kích thước	Dài 152 mm - Ngang 74.4 mm - Dày 8.3 mm
Trọng lượng	175 g
Thông tin pin & Sạc
Dung lượng pin	4000 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin, Sạc nhanh Quick Charge 3.0
Tiện ích
Bảo mật nâng cao	Mở khoá vân tay dưới màn hình
Tính năng đặc biệt	Nhân bản ứng dụng
Chặn tin nhắn
Đèn pin
Trợ lý ảo Google Assistant
Ghi âm cuộc gọi
Chặn cuộc gọi
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Có
Xem phim	WMV, H.263, H.264(MPEG4-AVC)
Nghe nhạc	MP3, WAV, WMA
Thông tin khác
Thời điểm ra mắt	08/2019', null, 0, 3790000, 100000, 1, '2019-12-24 12:31:00');
INSERT INTO product VALUES (48, 2, 1, null, 'Điện thoại Nokia 6.1 Plus', 3590000, '2019-12-24 12:00:00', '2020-01-14 10:47:00', 'Màn hình
Công nghệ màn hình	IPS LCD
Độ phân giải	Full HD+ (1080 x 2280 Pixels)
Màn hình rộng	5.8"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 3
Camera sau
Độ phân giải	Chính 16 MP & Phụ 5 MP
Quay phim	Quay phim FullHD 1080p@30fps, Quay phim 4K 2160p@30fps
Đèn Flash	Đèn LED 2 tông màu
Chụp ảnh nâng cao	Xoá phông, Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Làm đẹp (Beautify)
Camera trước
Độ phân giải	16 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Nhãn dán (AR Stickers), Nhận diện khuôn mặt, Quay video Full HD, Tự động lấy nét (AF), HDR, Làm đẹp (Beautify)
Hệ điều hành - CPU
Hệ điều hành	Android 8 Oreo (Android One)
Chipset (hãng SX CPU)	Snapdragon 636 8 nhân
Tốc độ CPU	1.8 GHz
Chip đồ họa (GPU)	Adreno 509
Bộ nhớ & Lưu trữ
RAM	4 GB
Bộ nhớ trong	64 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 51 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 400 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 SIM Nano (SIM 2 chung khe thẻ nhớ)
Wifi	Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	LE, A2DP, v5.0
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	USB 2.0
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung kim loại & Mặt lưng kính cường lực
Kích thước	Dài 147.2 mm - Ngang 71 mm - Dày 8 mm
Trọng lượng	153 g
Thông tin pin & Sạc
Dung lượng pin	3060 mAh
Loại pin	Pin chuẩn Li-Ion
Công nghệ pin	Tiết kiệm pin
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay
Tính năng đặc biệt	Chặn tin nhắn
Chặn cuộc gọi
Đèn pin
Ghi âm	Không
Radio	Có
Xem phim	3GP, MP4, WMV
Nghe nhạc	AMR, MP3, WAV, AAC, OGG, FLAC
Thông tin khác
Thời điểm ra mắt	08/2018', null, 0, 3590000, 100000, 1, '2019-12-24 12:32:00');
INSERT INTO product VALUES (49, 2, 1, null, 'Điện thoại Realme 3 32GB', 2990000, '2019-12-24 12:00:00', '2020-01-8 5:4:00', 'Màn hình
Công nghệ màn hình	IPS LCD
Độ phân giải	HD+ (720 x 1520 Pixels)
Màn hình rộng	6.22"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 3
Camera sau
Độ phân giải	Chính 13 MP & Phụ 2 MP
Quay phim	Quay phim FullHD 1080p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Xoá phông, Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Làm đẹp (Beautify)
Camera trước
Độ phân giải	13 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	HDR, Tự động lấy nét (AF), Làm đẹp (Beautify)
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	MediaTek Helio P60 8 nhân
Tốc độ CPU	2.0 GHz
Chip đồ họa (GPU)	Mali-G72 MP3
Bộ nhớ & Lưu trữ
RAM	3 GB
Bộ nhớ trong	32 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 20 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 256 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 b/g/n, Wi-Fi hotspot
GPS	A-GPS, GLONASS
Bluetooth	LE, A2DP, v4.2
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Kết nối khác	Không
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 156.1 mm - Ngang 75.6 mm - Dày 8.3 mm
Trọng lượng	175 g
Thông tin pin & Sạc
Dung lượng pin	4230 mAh
Loại pin	Pin chuẩn Li-Ion
Công nghệ pin	Tiết kiệm pin
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Chặn tin nhắn
Chặn cuộc gọi
Đèn pin
Ghi âm	Có
Radio	Có
Xem phim	3GP, MP4, AVI, WMV
Nghe nhạc	AMR, MP3, WAV, WMA, AAC, OGG, FLAC
Thông tin khác
Thời điểm ra mắt	04/2019', null, 0, 2990000, 100000, 1, '2019-12-24 12:33:00');
INSERT INTO product VALUES (50, 2, 1, null, 'Điện thoại Xiaomi Redmi Note 8 (3GB/32GB)', 3990000, '2019-12-24 12:00:00', '2020-01-7 18:18:00', 'Màn hình
Công nghệ màn hình	IPS LCD
Độ phân giải	Full HD+ (1080 x 2340 Pixels)
Màn hình rộng	6.3"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 5
Camera sau
Độ phân giải	Chính 48 MP & Phụ 8 MP, 2 MP, 2 MP
Quay phim	Quay phim HD 720p@30fps, Quay phim FullHD 1080p@30fps, Quay phim FullHD 1080p@60fps, Quay phim 4K 2160p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Quay siêu chậm (Super Slow Motion), Lấy nét theo pha (PDAF), A.I Camera, Siêu độ phân giải, Ban đêm (Night Mode), Trôi nhanh thời gian (Time Lapse), Quay chậm (Slow Motion), Xoá phông, Chống rung điện tử kỹ thuật số (EIS), Google Lens, Góc rộng (Wide), Siêu cận (Macro), Góc siêu rộng (Ultrawide), Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Làm đẹp (Beautify)
Camera trước
Độ phân giải	13 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Flash màn hình, Quay video HD, Chụp bằng cử chỉ, Nhận diện khuôn mặt, Làm đẹp (Beautify), Quay video Full HD, Tự động lấy nét (AF), HDR
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Snapdragon 665 8 nhân
Tốc độ CPU	4 nhân 2.0 GHz & 4 nhân 1.8 GHz
Chip đồ họa (GPU)	Adreno 610
Bộ nhớ & Lưu trữ
RAM	3 GB
Bộ nhớ trong	32 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 17 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 256 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	A2DP, LE, v4.2
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	OTG, Hồng Ngoại
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung kim loại & Mặt lưng kính cường lực
Kích thước	Dài 158.3 mm - Ngang 75.3 mm - Dày 8.4 mm
Trọng lượng	190 g
Thông tin pin & Sạc
Dung lượng pin	4000 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin, Sạc pin nhanh
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Đèn pin
Chạm 2 lần sáng màn hình
Sạc pin nhanh
Chặn cuộc gọi
Báo rung khi kết nối cuộc gọi
Chặn tin nhắn
Mặt kính 2.5D
Thu nhỏ màn hình sử dụng một tay
Nhân bản ứng dụng
Khoá ứng dụng
Đa cửa sổ (chia đôi màn hình)
Không gian trò chơi
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Có
Xem phim	MP4, AVI
Nghe nhạc	MP3, WAV
Thông tin khác
Thời điểm ra mắt	10/2019', null, 0, 3990000, 100000, 1, '2019-12-24 12:34:00');
INSERT INTO product VALUES (51, 2, 1, null, 'Điện thoại Realme 5 (3GB/64GB)', 3690000, '2019-12-24 12:00:00', '2020-01-1 7:50:00', 'Màn hình
Công nghệ màn hình	IPS LCD
Độ phân giải	HD+ (720 x 1600 Pixels)
Màn hình rộng	6.5"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass 3
Camera sau
Độ phân giải	Chính 12 MP & Phụ 8 MP, 2 MP, 2 MP
Quay phim	Quay phim HD 720p@30fps, Quay phim FullHD 1080p@30fps, Quay phim 4K 2160p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Góc siêu rộng (Ultrawide), Siêu cận (Macro), Góc rộng (Wide), Chống rung điện tử kỹ thuật số (EIS), Xoá phông, Trôi nhanh thời gian (Time Lapse), Ban đêm (Night Mode), Lấy nét theo pha (PDAF), Quay chậm (Slow Motion), Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Làm đẹp (Beautify), Chuyên nghiệp (Pro)
Camera trước
Độ phân giải	13 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	HDR, Quay video Full HD, Tự động lấy nét (AF), Làm đẹp (Beautify), Xoá phông, Flash màn hình, Quay video HD, Nhận diện khuôn mặt
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Snapdragon 665 8 nhân
Tốc độ CPU	4 nhân 2.0 GHz & 4 nhân 1.8 GHz
Chip đồ họa (GPU)	Adreno 610
Bộ nhớ & Lưu trữ
RAM	3 GB
Bộ nhớ trong	64 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 49 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 256 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 a/b/g/n/ac, Dual-band, DLNA, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	A2DP, LE, v5.0
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Kết nối khác	OTG
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 164.4 mm - Ngang 75.6 mm - Dày 9.3 mm
Trọng lượng	198 g
Thông tin pin & Sạc
Dung lượng pin	5000 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Đèn pin
Không gian trò chơi
Đa cửa sổ (chia đôi màn hình)
Nhân bản ứng dụng
Mặt kính 2.5D
Chặn tin nhắn
Chặn cuộc gọi
Ghi âm cuộc gọi
Trợ lý ảo Google Assistant
Ghi âm	Có
Radio	Có
Xem phim	3GP, MP4, AVI, WMV
Nghe nhạc	AMR, MP3, WAV, WMA, AAC, OGG, FLAC
Thông tin khác
Thời điểm ra mắt	10/2019', null, 0, 3690000, 100000, 1, '2019-12-24 12:35:00');
INSERT INTO product VALUES (52, 2, 1, null, 'Điện thoại Samsung Galaxy A20', 4190000, '2019-12-24 12:00:00', '2020-01-4 6:41:00', 'Màn hình
Công nghệ màn hình	Super AMOLED
Độ phân giải	HD+ (720 x 1560 Pixels)
Màn hình rộng	6.4"
Mặt kính cảm ứng	Kính cường lực Corning Gorilla Glass
Camera sau
Độ phân giải	Chính 13 MP & Phụ 5 MP
Quay phim	Quay phim FullHD 1080p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Xoá phông, Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Làm đẹp (Beautify)
Camera trước
Độ phân giải	8 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Quay video HD, Làm đẹp (Beautify), Tự động lấy nét (AF)
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Exynos 7884 8 nhân
Tốc độ CPU	2 nhân 1.6 GHz & 6 nhân 1.35 GHz
Chip đồ họa (GPU)	Mali-G71
Bộ nhớ & Lưu trữ
RAM	3 GB
Bộ nhớ trong	32 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 22 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 512 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 b/g/n, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	LE, A2DP, v4.2
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	Không
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 158.4 mm - Ngang 74.7 mm - Dày 7.8 mm
Trọng lượng	169 g
Thông tin pin & Sạc
Dung lượng pin	4000 mAh
Loại pin	Pin chuẩn Li-Ion
Công nghệ pin	Tiết kiệm pin, Sạc pin nhanh
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Nhân bản ứng dụng
Mặt kính 2.5D
Chặn tin nhắn
Ghi âm cuộc gọi
Đèn pin
Chặn cuộc gọi
Dolby Audio™
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Có
Xem phim	3GP, MP4, AVI, WMV
Nghe nhạc	AMR, Midi, MP3, WAV, WMA, AAC, OGG, FLAC
Thông tin khác
Thời điểm ra mắt	04/2019', null, 0, 4190000, 100000, 1, '2019-12-24 12:36:00');
INSERT INTO product VALUES (53, 2, 1, null, 'Điện thoại Vivo Y17', 4390000, '2019-12-24 12:00:00', '2020-01-7 3:8:00', 'Màn hình
Công nghệ màn hình	IPS LCD
Độ phân giải	HD+ (720 x 1544 Pixels)
Màn hình rộng	6.35"
Mặt kính cảm ứng	Mặt kính cong 2.5D
Camera sau
Độ phân giải	Chính 13 MP & Phụ 8 MP, 2 MP
Quay phim	Quay phim HD 720p@30fps, Quay phim FullHD 1080p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Chụp bằng giọng nói, Góc rộng (Wide), Chụp bằng cử chỉ, Góc siêu rộng (Ultrawide), Xoá phông, Quay chậm (Slow Motion), Trôi nhanh thời gian (Time Lapse), Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Làm đẹp (Beautify), Chuyên nghiệp (Pro)
Camera trước
Độ phân giải	20 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Xoá phông, Flash màn hình, Toàn cảnh (Panorama), Chụp bằng cử chỉ, Chụp bằng giọng nói, Nhận diện khuôn mặt, Làm đẹp (Beautify), Quay video Full HD, Tự động lấy nét (AF), HDR, Quay video HD
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	MediaTek Helio P35 8 nhân
Tốc độ CPU	4 nhân 2.3 GHz & 4 nhân 1.8 GHz
Chip đồ họa (GPU)	PowerVR GE8320
Bộ nhớ & Lưu trữ
RAM	4 GB
Bộ nhớ trong	128 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 115 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 256 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 b/g/n, Dual-band, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	LE, A2DP, v5.0
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Kết nối khác	OTG
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 159.4 mm - Ngang 76.8 mm - Dày 8.9 mm
Trọng lượng	190.5 g
Thông tin pin & Sạc
Dung lượng pin	5000 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin, Siêu tiết kiệm pin, Sạc pin nhanh
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Trợ lý ảo Jovi
Nhân bản ứng dụng
Khoá ứng dụng
Không gian trẻ em
Thu nhỏ màn hình sử dụng một tay
Vẽ lên màn hình để mở nhanh ứng dụng
Mặt kính 2.5D
Chặn tin nhắn
Chặn cuộc gọi
Chạm 2 lần tắt màn hình
Sạc pin nhanh
Chạm 2 lần sáng màn hình
Đèn pin
Không gian trò chơi
Đa cửa sổ (chia đôi màn hình)
Ghi âm	Có
Radio	Có
Xem phim	3GP, MP4, AVI
Nghe nhạc	Midi, AMR, MP3, WAV, FLAC
Thông tin khác
Thời điểm ra mắt	08/2019', null, 0, 4390000, 100000, 1, '2019-12-24 12:37:00');
INSERT INTO product VALUES (54, 2, 1, null, 'Điện thoại Samsung Galaxy A20s 32GB', 4390000, '2019-12-24 12:00:00', '2020-01-9 3:24:00', 'Màn hình
Công nghệ màn hình	IPS LCD
Độ phân giải	HD+ (720 x 1520 Pixels)
Màn hình rộng	6.5"
Mặt kính cảm ứng	Mặt kính cong 2.5D
Camera sau
Độ phân giải	Chính 13 MP & Phụ 8 MP, 5 MP
Quay phim	Quay phim FullHD 1080p@30fps
Đèn Flash	Có
Chụp ảnh nâng cao	Xoá phông, Góc siêu rộng (Ultrawide), Tự động lấy nét (AF), Chạm lấy nét, Nhận diện khuôn mặt, HDR, Toàn cảnh (Panorama), Làm đẹp (Beautify)
Camera trước
Độ phân giải	8 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Tự động lấy nét (AF), Quay video HD, Nhận diện khuôn mặt, Làm đẹp (Beautify), Quay video Full HD
Hệ điều hành - CPU
Hệ điều hành	Android 9.0 (Pie)
Chipset (hãng SX CPU)	Snapdragon 450 8 nhân
Tốc độ CPU	1.8 GHz
Chip đồ họa (GPU)	Adreno 506
Bộ nhớ & Lưu trữ
RAM	3 GB
Bộ nhớ trong	32 GB
Bộ nhớ còn lại (khả dụng)	Khoảng 24 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 512 GB
Kết nối
Mạng di động	Hỗ trợ 4G
SIM	2 Nano SIM
Wifi	Wi-Fi 802.11 b/g/n, Wi-Fi Direct, Wi-Fi hotspot
GPS	BDS, A-GPS, GLONASS
Bluetooth	LE, A2DP, v5.0
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Kết nối khác	OTG
Thiết kế & Trọng lượng
Thiết kế	Nguyên khối
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 163.3 mm - Ngang 77.5 mm - Dày 8 mm
Trọng lượng	183 g
Thông tin pin & Sạc
Dung lượng pin	4000 mAh
Loại pin	Pin chuẩn Li-Po
Công nghệ pin	Tiết kiệm pin, Sạc pin nhanh
Tiện ích
Bảo mật nâng cao	Mở khóa bằng vân tay, Mở khoá khuôn mặt
Tính năng đặc biệt	Nhân bản ứng dụng
Mặt kính 2.5D
Chặn cuộc gọi
Chặn tin nhắn
Đèn pin
Ghi âm	Có, microphone chuyên dụng chống ồn
Radio	Không
Xem phim	3GP, MP4, AVI, WMV
Nghe nhạc	Midi, AMR, MP3, WAV, WMA, AAC, OGG, FLAC
Thông tin khác
Thời điểm ra mắt	10/2019', null, 0, 4390000, 100000, 1, '2019-12-24 12:38:00');
INSERT INTO product VALUES (55, 2, 1, null, 'Điện thoại Mobell Nova P3', 1650000, '2019-12-24 12:00:00', '2020-01-12 3:52:00', 'Màn hình
Công nghệ màn hình	IPS LCD
Độ phân giải	HD (720 x 1280 Pixels)
Màn hình rộng	5.5"
Mặt kính cảm ứng	Kính thường
Camera sau
Độ phân giải	8 MP
Quay phim	Có quay phim
Đèn Flash	Có
Chụp ảnh nâng cao	Tự động lấy nét (AF), Chạm lấy nét, Làm đẹp (Beautify)
Camera trước
Độ phân giải	8 MP
Videocall	Hỗ trợ VideoCall thông qua ứng dụng
Thông tin khác	Làm đẹp (Beautify)
Hệ điều hành - CPU
Hệ điều hành	Android 7.0 (Nougat)
Chipset (hãng SX CPU)	MediaTek MT6580 4 nhân
Tốc độ CPU	1.3 GHz
Chip đồ họa (GPU)	Mali-400 MP
Bộ nhớ & Lưu trữ
RAM	2 GB
Bộ nhớ trong	16 GB
Bộ nhớ còn lại (khả dụng)	11.7 GB
Thẻ nhớ ngoài	MicroSD, hỗ trợ tối đa 32 GB
Kết nối
Mạng di động	3G
SIM	2 Micro SIM
Wifi	Wi-Fi 802.11 b/g/n, Wi-Fi Direct, Wi-Fi hotspot
GPS	A-GPS
Bluetooth	v4.0
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Kết nối khác	OTG
Thiết kế & Trọng lượng
Thiết kế	Pin rời
Chất liệu	Khung & Mặt lưng nhựa
Kích thước	Dài 154.6 mm - Ngang 77.3 mm - Dày 8.6 mm
Trọng lượng	180 g
Thông tin pin & Sạc
Dung lượng pin	3250 mAh
Loại pin	Pin chuẩn Li-Ion
Công nghệ pin	Tiết kiệm pin
Tiện ích
Bảo mật nâng cao	Không
Tính năng đặc biệt	Sạc pin cho thiết bị khác
Ghi âm	Có
Radio	Có
Xem phim	3GP, MP4, AVI, WMV
Nghe nhạc	MP3, WAV, WMA
Thông tin khác
Thời điểm ra mắt	11/2016', null, 0, 1650000, 100000, 1, '2019-12-24 12:39:00');
INSERT INTO product VALUES (56, 7, 1, null, 'Polymer 10.000mAh Xiaomi Mi 18W ', 499000, '2019-12-24 12:00:00', '2020-01-4 10:15:00', 'Thiết kế mỏng nhẹ, màu sắc trang nhã.
Tích hợp 2 cổng sạc vào (input) Micro USB và Type C giúp việc chọn cáp sạc dễ dàng hơn.
Trang bị 2 cổng sạc ra (output) USB giúp bạn sạc được đồng thời 2 thiết bị.
Sử dụng lõi pin Polymer an toàn bảo vệ khỏi quá dòng, quá tải cho các thiết bị.
Tương thích với nhiều loại điện thoại và máy tính bảng.', null, 0, 499000, 100000, 1, '2019-12-24 12:40:00');
INSERT INTO product VALUES (57, 7, 1, null, 'Energizer 10.000 mAh QE10000GY', 675000, '2019-12-24 12:00:00', '2020-01-4 3:2:00', 'Thiết kế vỏ ngoài bằng kim loại giúp bảo vệ pin tránh va chạm mạnh trong quá trình sử dụng.
Chuẩn Qi tương thích với tất cả các thiết bị hỗ trợ sạc không dây.
Hỗ trợ cổng Type-C output với khả năng sạc nhanh lên đến 5V - 3A.
2 cổng input microUSB và Type-C giúp việc lựa chọn cáp sạc cho pin dự phòng dễ dàng hơn.
Đèn Led thông báo tình trạng pin, mỗi vạch tương ứng với 25% mức pin.
Tích hợp công nghệ Auto Voltage Sensing - tự động cảm biến điện áp giúp tương thích với mọi thiết bị di động.
Chứng nhận về an toàn & chống cháy nổ: CE, FCC, ETL, CB, EAC, RoHS, Reach, ERP6, DOE6.
Energizer - Thương hiệu nổi tiếng thế giới đến từ Mỹ.', null, 0, 675000, 100000, 1, '2019-12-24 12:41:00');
INSERT INTO product VALUES (58, 7, 1, null, 'Bluetooth True Wireless Huawei FreeBuds 3', 4290000, '2019-12-24 12:00:00', '2020-01-8 12:36:00', 'Thiết kế nhỏ gọn, êm ái, đảm bảo thoải mái khi sử dụng.
Chất lượng âm thanh sống động, bass mạnh mẽ, chân thực.
Sử dụng chip Kirin A1 với tốc độ truyền tín hiệu lớn.
Kết nối Bluetooth chuẩn 5.1 hiện đại, truyền tín hiệu ổn định, âm thanh mượt mà.
Tích hợp tính năng khử tiếng ồn chủ động ANC cho âm thanh thuần túy hơn.
Cảm biến giọng nói qua khung xương tai.
Thời lượng pin cao với 4 tiếng sử dụng cùng 20 tiếng qua hộp sạc.
Dễ dàng điều kiển nhạc, nhận cuộc gọi, bật tắt ANC bằng cách gõ vào tai nghe.
Sau lần kết nối đầu tiên, các lần sau tai nghe sẽ tự động kết nối với điện thoại nhanh chóng.', null, 0, 4290000, 100000, 1, '2019-12-24 12:42:00');
INSERT INTO product VALUES (59, 7, 1, null, 'Bluetooth Sony WH-XB700', 2990000, '2019-12-24 12:00:00', '2020-01-7 12:1:00', 'Thiết kế năng động, tin xảo đầy cuốn hút.
Đệm tai êm mang lại cảm giác thoải mái khi đeo trong thời gian dài.
Kết nối không dây với công nghệ kết nối 1 chạm NFC và Bluetooth.
Tích hợp trợ lý giọng nói Google Assistant tiện lợi, hiện đại.
Tương thích hầu hết điện thoại, máy tính bảng, laptop hiện nay.
Một lần sạc khoảng 4 giờ sẽ cho bạn sử dụng suốt ngày dài với thời gian phát nhạc xấp xỉ 30 giờ.
Nếu tai nghe sắp hết pin, chỉ cần sạc nhanh trong 10 phút là bạn có thể nghe nhạc thêm tới 90 phút.
Trang bị micro hỗ trợ đàm thoại và nhiều nút tính năng tiện lợi, dễ thao tác.
Thương hiệu Sony đến từ Nhật Bản, nổi tiếng toàn cầu trong lĩnh vực công nghệ, điện tử.', null, 0, 2990000, 100000, 1, '2019-12-24 12:43:00');
INSERT INTO product VALUES (60, 7, 1, null, 'Thẻ nhớ MicroSD 8 GB Class 4', 120000, '2019-12-24 12:00:00', '2020-01-8 15:37:00', 'Thương hiệu uy tín trong lĩnh vực sản xuất thẻ nhớ: SanDisk, Transcend, Apacer.
Giao ngẫu nhiên 1 trong 3 thương hiệu.
Tốc độ đọc: 30 MB/s.
Tốc độ ghi: 4 MB/s.
Tương thích tốt với điện thoại, máy tính bảng.
Tương thích với thiết bị có thể nhận thẻ nhớ tối đa 8 GB.
Chép một video 1 GB vào thẻ nhớ trong gần 4 phút rưỡi.
Lưu trữ hơn 2.600 bài hát (1 bài ~3 MB).', null, 0, 120000, 100000, 1, '2019-12-24 12:44:00');
INSERT INTO product VALUES (61, 7, 1, null, 'Thẻ nhớ MicroSD 128 GB Class 10', 872000, '2019-12-24 12:00:00', '2020-01-4 5:42:00', 'Thương hiệu uy tín trong lĩnh vực sản xuất thẻ nhớ: SanDisk, Transcend.
Giao ngẫu nhiên 1 trong 2 thương hiệu.
Kèm theo Adapter chuyển đổi từ Micro SD (TF) sang SD.
Tốc độ đọc: 45 MB/s.
Tốc độ ghi: 10 MB/s.
Tương thích tốt với điện thoại, máy tính bảng.
Tương thích với thiết bị có thể nhận thẻ nhớ tối đa 128 GB.
Chép một video dung lượng 1 GB vào thẻ chưa tới 2 phút.
Lưu trữ hơn 40.000 bài hát (1 bài ~3 MB).', null, 0, 872000, 100000, 1, '2019-12-24 12:45:00');
INSERT INTO product VALUES (62, 7, 1, null, 'Ổ cứng HDD 1TB WD My Passport Xanh Dương', 1590000, '2019-12-24 12:00:00', '2020-01-15 23:48:00', 'Thiết kế cứng cáp, chắc tay với những đường vân lượn sóng.
 Ổ được định dạng sẵn để sử dụng ngay với hệ điều hành Windows 10, Windows 8, Windows 7.
Tương thích laptop, máy tính cổng USB 3.0 hoặc USB 2.0.', null, 0, 1590000, 100000, 1, '2019-12-24 12:46:00');
INSERT INTO product VALUES (63, 7, 1, null, 'Ổ cứng HDD 1TB Seagate Backup Plus Slim Đen', 1690000, '2019-12-24 12:00:00', '2020-01-10 14:20:00', 'Thiết kế nhỏ gọn, mỏng nhẹ với chất liệu nhựa và nhôm.
Tiện ích đi kèm: Seagate Dashboard, trình điều khiển NTFS cho Mac.
Tương thích với hệ điều hành Window 7 trở lên, MacOS X 10.7 trở lên.
Tương thích laptop, máy tính cổng USB 3.0 hoặc USB 2.0.', null, 0, 1690000, 100000, 1, '2019-12-24 12:47:00');
INSERT INTO product VALUES (64, 8, 1, null, 'iPad 10.2 inch Wifi 128GB', 11990000, '2019-12-24 12:00:00', '2020-01-7 4:57:00', 'Màn hình

Công nghệ màn hình	LED backlit LCD
Độ phân giải	2160 x 1620 pixels
Kích thước màn hình	10.2"

Chụp ảnh & Quay phim

Camera sau	8 MP
Quay phim	Full HD 1080p@30fps
Tính năng camera	Gắn thẻ địa lý, Tự động lấy nét, Chạm lấy nét, Nhận diện khuôn mặt, Panorama, Slow Motion
Camera trước	1.2 MP

Cấu hình

Hệ điều hành	iOS 13
Loại CPU (Chipset)	Apple A10 Fusion 4 nhân
Tốc độ CPU	2.34 GHz
Chip đồ hoạ (GPU)	PowerVR Series 7
RAM	3 GB
Bộ nhớ trong (ROM)	128 GB
Bộ nhớ khả dụng	Khoảng 115 GB
Thẻ nhớ ngoài	Không
Hỗ trợ thẻ tối đa	Không
Cảm biến	La bàn, Con quay hồi chuyển 3 chiều, Fingerprint Sensor, Ánh sáng, Gia tốc

Kết nối

Số khe SIM	Không
Loại SIM	Không
Thực hiện cuộc gọi	FaceTime
Hỗ trợ 3G	Không 3G
Hỗ trợ 4G	Không hỗ trợ 4G
WiFi	Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot
Bluetooth	LE, A2DP, 4.2, EDR
GPS	A-GPS, GLONASS
Cổng kết nối/sạc	Lightning
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Có
Kết nối khác	Không

Chức năng khác

Ghi âm	Có
Radio	Không
Tính năng đặc biệt	Mở khóa bằng vân tay

Thiết kế & Trọng lượng

Chất liệu	Kim loại
Kích thước	Dài 250.6 mm - Ngang 174.1 mm - Dày 7.5 mm
Trọng lượng	483 g

Pin & Dung lượng

Loại pin	Lithium - Ion
Mức năng lượng tiêu thụ	32.4 Wh (Khoảng 8600 mAh)', null, 0, 11990000, 100000, 1, '2019-12-24 12:48:00');
INSERT INTO product VALUES (65, 8, 1, null, 'Samsung Galaxy Tab A8 8" T295', 3690000, '2019-12-24 12:00:00', '2020-01-2 4:42:00', 'Màn hình

Công nghệ màn hình	TFT LCD
Độ phân giải	1280 x 800 pixels
Kích thước màn hình	8"

Chụp ảnh & Quay phim

Camera sau	8 MP
Quay phim	Full HD 1080p@30fps
Tính năng camera	Tự động lấy nét, Nhận diện khuôn mặt
Camera trước	2 MP

Cấu hình

Hệ điều hành	Android 9.0 (Pie)
Loại CPU (Chipset)	Snapdragon 429
Tốc độ CPU	4 nhân 2.0 GHz
Chip đồ hoạ (GPU)	Adreno 504
RAM	2 GB
Bộ nhớ trong (ROM)	32 GB
Bộ nhớ khả dụng	Khoảng 26 GB
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	512 GB
Cảm biến	Rung, Tiệm cận, Gia tốc

Kết nối

Số khe SIM	1 SIM
Loại SIM	Nano Sim
Thực hiện cuộc gọi	Có
Hỗ trợ 3G	Có 3G
Hỗ trợ 4G	4G LTE
WiFi	Wi-Fi 802.11 b/g/n
Bluetooth	4.2
GPS	Không
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Có
Kết nối khác	Không

Chức năng khác

Ghi âm	Không
Radio	Không
Tính năng đặc biệt	Không

Thiết kế & Trọng lượng

Chất liệu	Kim loại
Kích thước	Dài 210 mm - Ngang 124.4 mm - Dày 8 mm
Trọng lượng	347 g

Pin & Dung lượng

Loại pin	Lithium - Ion
Dung lượng pin	5100 mAh', null, 0, 3690000, 100000, 1, '2019-12-24 12:49:00');
INSERT INTO product VALUES (66, 8, 1, null, 'Lenovo Tab E10 TB-X104L', 3590000, '2019-12-24 12:00:00', '2020-01-12 13:5:00', 'Màn hình

Công nghệ màn hình	IPS LCD
Độ phân giải	1280 x 800 pixels
Kích thước màn hình	10.1"

Chụp ảnh & Quay phim

Camera sau	5 MP
Quay phim	Có quay phim, HD 720p
Tính năng camera	Chạm lấy nét, Nhận diện khuôn mặt, Nhận diện nụ cười
Camera trước	2 MP

Cấu hình

Hệ điều hành	Android 8.0
Loại CPU (Chipset)	Snapdragon 210 4 nhân
Tốc độ CPU	1.33 GHz
Chip đồ hoạ (GPU)	Integrated Qualcomm Adreno 304 GPU
RAM	2 GB
Bộ nhớ trong (ROM)	16 GB
Bộ nhớ khả dụng	Khoảng 12 GB
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	128 GB
Cảm biến	La bàn

Kết nối

Số khe SIM	1 SIM
Loại SIM	Nano Sim
Thực hiện cuộc gọi	Không
Hỗ trợ 3G	Có 3G
Hỗ trợ 4G	4G LTE
WiFi	Wi-Fi 802.11 b/g/n
Bluetooth	4.0
GPS	A-GPS
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Có
Kết nối khác	MHL, Miracast

Chức năng khác

Ghi âm	Có
Radio	Có
Tính năng đặc biệt	Dolby Atmos

Thiết kế & Trọng lượng

Chất liệu	Nhựa ABS
Kích thước	Dài 247 mm - Ngang 171 mm - Dày 7 mm
Trọng lượng	522 g

Pin & Dung lượng

Loại pin	Lithium - Ion
Dung lượng pin	4850 mAh', null, 0, 3590000, 100000, 1, '2019-12-24 12:50:00');
INSERT INTO product VALUES (67, 8, 1, null, 'Mobell Tab 8 Pro', 2250000, '2019-12-24 12:00:00', '2020-01-12 10:49:00', 'Màn hình

Công nghệ màn hình	IPS LCD
Độ phân giải	1280 x 800 pixels
Kích thước màn hình	8"

Chụp ảnh & Quay phim

Camera sau	8 MP
Quay phim	Có quay phim
Tính năng camera	Đèn Flash, Tự động lấy nét, Chạm lấy nét, Nhận diện khuôn mặt, Nhận diện nụ cười, Panorama
Camera trước	5 MP

Cấu hình

Hệ điều hành	Android 5.1
Loại CPU (Chipset)	MediaTek MTK 8321 4 nhân
Tốc độ CPU	1.33 GHz
Chip đồ hoạ (GPU)	Mali-400 MP
RAM	1 GB
Bộ nhớ trong (ROM)	16 GB
Bộ nhớ khả dụng	10.5 GB
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	32 GB
Cảm biến	Tiệm cận, Gia tốc, Ánh sáng

Kết nối

Số khe SIM	2 SIM
Loại SIM	Nano SIM, SIM 2 chung khe thẻ nhớ
Thực hiện cuộc gọi	Có
Hỗ trợ 3G	Có 3G ( tốc độ Download 21 Mbps, Upload 5.76 Mbps)
Hỗ trợ 4G	Không hỗ trợ 4G
WiFi	Wi-Fi 802.11 b/g/n, Wi-Fi Direct, Wi-Fi hotspot
Bluetooth	4.0
GPS	A-GPS
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Có
Kết nối khác	Không

Chức năng khác

Ghi âm	Có
Radio	Có
Tính năng đặc biệt	Dolby Audio™

Thiết kế & Trọng lượng

Chất liệu	Mặt lưng nhôm
Kích thước	Dài 209 mm - Ngang 121 mm - Dày 7.9 mm
Trọng lượng	236 g

Pin & Dung lượng

Loại pin	Lithium - Ion
Dung lượng pin	5200 mAh', null, 0, 2250000, 100000, 1, '2019-12-24 12:51:00');
INSERT INTO product VALUES (68, 8, 1, null, 'Lenovo Tab E7 TB-7104I', 1890000, '2019-12-24 12:00:00', '2020-01-5 19:28:00', 'Màn hình

Công nghệ màn hình	IPS LCD
Độ phân giải	1024 x 600 pixels
Kích thước màn hình	7"
Chụp ảnh & Quay phim
Camera sau	2 MP
Quay phim	Có quay phim
Tính năng camera	Tự động lấy nét, Chạm lấy nét, Nhận diện khuôn mặt
Camera trước	0.3 MP

Cấu hình

Hệ điều hành	Android Go 8.1
Loại CPU (Chipset)	Mediatek MT8167D 6 nhân
Tốc độ CPU	1.3 GHz
Chip đồ hoạ (GPU)	Integrated IMG GE8300 Graphics
RAM	1 GB
Bộ nhớ trong (ROM)	16 GB
Bộ nhớ khả dụng	12,8 GB
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	128 GB
Cảm biến	Rung, Tiệm cận, Gia tốc

Kết nối

Số khe SIM	1 SIM
Loại SIM	SIM thường
Thực hiện cuộc gọi	Có
Hỗ trợ 3G	Có 3G
Hỗ trợ 4G	Không hỗ trợ 4G
WiFi	Wi-Fi 802.11 b/g/n
Bluetooth	4.0
GPS	A-GPS
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Không
Kết nối khác	Không

Chức năng khác

Ghi âm	Có
Radio	Không
Tính năng đặc biệt	Không

Thiết kế & Trọng lượng

Chất liệu	Nhựa
Kích thước	Dài 193.2 mm - Ngang 110.5 mm - Dày 10.3 mm
Trọng lượng	271.7 g

Pin & Dung lượng

Loại pin	Lithium - Ion
Dung lượng pin	2750mAh', null, 0, 1890000, 100000, 1, '2019-12-24 12:52:00');
INSERT INTO product VALUES (69, 8, 1, null, 'iPad Mini 7.9 inch Wifi 64GB', 10990000, '2019-12-24 12:00:00', '2020-01-11 0:32:00', 'Màn hình

Công nghệ màn hình	LED backlit LCD
Độ phân giải	1536 x 2048 pixels
Kích thước màn hình	7.9"

Chụp ảnh & Quay phim

Camera sau	8 MP
Quay phim	Full HD 1080p (1920 x 1080 pixels)
Tính năng camera	Chế độ làm đẹp, Tự động lấy nét, Chạm lấy nét, Nhận diện khuôn mặt, Nhận diện nụ cười, HDR, Panorama
Camera trước	7 MP

Cấu hình

Hệ điều hành	iOS 12
Loại CPU (Chipset)	Apple A12 Bionic 6 nhân
Tốc độ CPU	2 nhân 2.5 GHz & 4 nhân 1.6 GHz
Chip đồ hoạ (GPU)	Apple GPU 4 nhân
RAM	3 GB
Bộ nhớ trong (ROM)	64 GB
Bộ nhớ khả dụng	54GB
Thẻ nhớ ngoài	Không
Hỗ trợ thẻ tối đa	Không
Cảm biến	Rung, Tiệm cận, La bàn, Con quay hồi chuyển 3 chiều, Khí áp kế, Ánh sáng, Gia tốc

Kết nối

Số khe SIM	Không
Loại SIM	Không
Thực hiện cuộc gọi	FaceTime
Hỗ trợ 3G	Không 3G
Hỗ trợ 4G	Không hỗ trợ 4G
WiFi	Wi-Fi 802.11 b/g/n
Bluetooth	5.0
GPS	A-GPS
Cổng kết nối/sạc	Lightning
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Không
Kết nối khác	Không

Chức năng khác

Ghi âm	Có
Radio	Không
Tính năng đặc biệt	Mở khóa bằng vân tay, Gọi điện FaceTime

Thiết kế & Trọng lượng

Chất liệu	Kim loại nguyên khối
Kích thước	Dài 203 mm - Rộng 134 mm - Dày 6.1 mm
Trọng lượng	300 g

Pin & Dung lượng

Loại pin	Lithium - Polymer
Mức năng lượng tiêu thụ	19.1 Wh (Khoảng 5124 mAh)', null, 0, 10990000, 100000, 1, '2019-12-24 12:53:00');
INSERT INTO product VALUES (70, 8, 1, null, 'Huawei Mediapad T5', 5390000, '2019-12-24 12:00:00', '2020-01-2 2:6:00', 'Màn hình

Công nghệ màn hình	IPS LCD Full HD
Độ phân giải	1920 x 1280 pixels
Kích thước màn hình	10.1"

Chụp ảnh & Quay phim

Camera sau	5 MP
Quay phim	Full HD 1080p@30fps
Tính năng camera	Chế độ làm đẹp, Chế độ ánh sáng yếu, Nhận diện nụ cười
Camera trước	2 MP

Cấu hình

Hệ điều hành	Android 8.0
Loại CPU (Chipset)	Kirin 650 8 nhân
Tốc độ CPU	1.7 GHz
Chip đồ hoạ (GPU)	Mali-T830
RAM	3 GB
Bộ nhớ trong (ROM)	32 GB
Bộ nhớ khả dụng	
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	256 GB
Cảm biến	Rung, Tiệm cận, Gia tốc

Kết nối

Số khe SIM	1 SIM
Loại SIM	Micro sim
Thực hiện cuộc gọi	Có
Hỗ trợ 3G	Có
Hỗ trợ 4G	4G LTE
WiFi	Wi-Fi 802.11 a/b/g/n/ac
Bluetooth	4.2
GPS	GPS
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Có
Kết nối khác	Không

Chức năng khác

Ghi âm	Có
Radio	Không
Tính năng đặc biệt	Loa kép stereo, Không

Thiết kế & Trọng lượng

Chất liệu	Kim loại
Kích thước	Dài 243 mm - Ngang 164 mm - Dày 7.8 mm
Trọng lượng	470 g

Pin & Dung lượng

Loại pin	Lithium - Polymer
Dung lượng pin	5100 mAh', null, 0, 5390000, 100000, 1, '2019-12-24 12:54:00');
INSERT INTO product VALUES (71, 8, 1, null, 'Samsung Galaxy Tab with S Pen', 6990000, '2019-12-24 12:00:00', '2020-01-11 14:17:00', 'Màn hình

Công nghệ màn hình	WUXGA TFT
Độ phân giải	1920 x 1200 pixels
Kích thước màn hình	8"

Chụp ảnh & Quay phim

Camera sau	8 MP
Quay phim	Full HD 1080p@30fps
Tính năng camera	Tự động lấy nét, Nhận diện khuôn mặt
Camera trước	5 MP

Cấu hình

Hệ điều hành	Android 9.0 (Pie)
Loại CPU (Chipset)	Exynos 7904 8 nhân
Tốc độ CPU	2 nhân 1.8 GHz & 6 nhân 1.6 GHz
Chip đồ hoạ (GPU)	G71 MP2
RAM	3 GB
Bộ nhớ trong (ROM)	32 GB
Bộ nhớ khả dụng	Khoảng 26 GB
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	400 GB
Cảm biến	Rung, Tiệm cận, Gia tốc

Kết nối

Số khe SIM	1 SIM
Loại SIM	Nano Sim
Thực hiện cuộc gọi	Có
Hỗ trợ 3G	Có 3G
Hỗ trợ 4G	4G LTE
WiFi	Wi-Fi 802.11 b/g/n
Bluetooth	4.2
GPS	GPS
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Có
Kết nối khác	Không

Chức năng khác

Ghi âm	Không
Radio	Đang cập nhật
Tính năng đặc biệt	Hỗ trợ bút S Pen

Thiết kế & Trọng lượng

Chất liệu	Nhựa
Kích thước	Dài 212.1 mm - Ngang 124.1 mm - Dày 8.9 mm
Trọng lượng	380 g

Pin & Dung lượng

Loại pin	Lithium - Ion
Dung lượng pin	4200 mAh', null, 0, 6990000, 100000, 1, '2019-12-24 12:55:00');
INSERT INTO product VALUES (72, 8, 1, null, 'Huawei MediaPad M5 Lite', 7990000, '2019-12-24 12:00:00', '2020-01-6 18:28:00', 'Màn hình

Công nghệ màn hình	IPS LCD Full HD
Độ phân giải	1920 x 1200 pixels
Kích thước màn hình	10.1"

Chụp ảnh & Quay phim

Camera sau	8 MP
Quay phim	Full HD 1080p (1920 x 1080 pixels)
Tính năng camera	Chế độ làm đẹp, Tự động lấy nét, Panorama
Camera trước	8 MP

Cấu hình

Hệ điều hành	Android 8.0
Loại CPU (Chipset)	Kirin 659
Tốc độ CPU	1.7 GHz
Chip đồ hoạ (GPU)	Mali-T830
RAM	4 GB
Bộ nhớ trong (ROM)	64 GB
Bộ nhớ khả dụng	Đang cập nhật
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	256 GB
Cảm biến	Rung

Kết nối

Số khe SIM	1 SIM
Loại SIM	Nano Sim
Thực hiện cuộc gọi	Có
Hỗ trợ 3G	Có
Hỗ trợ 4G	4G LTE
WiFi	Wi-Fi 802.11 a/b/g/n/ac
Bluetooth	4.2
GPS	A-GPS, GPS, GLONASS
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Không
Kết nối khác	Không

Chức năng khác

Ghi âm	Có
Radio	Không
Tính năng đặc biệt	Mở khóa bằng vân tay, Hỗ trợ bút M Pen, Sạc pin nhanh

Thiết kế & Trọng lượng

Chất liệu	Kim loại
Kích thước	Dài 243.4 mm - Ngang 162.2 mm - Dày 7.7 mm
Trọng lượng	475 g

Pin & Dung lượng

Loại pin	Lithium - Polymer
Dung lượng pin	7500 mAh', null, 0, 7990000, 100000, 1, '2019-12-24 12:56:00');
INSERT INTO product VALUES (73, 8, 1, null, 'iPad Air 10.5 inch Wifi 64GB 2019', 13990000, '2019-12-24 12:00:00', '2020-01-10 4:37:00', 'Màn hình

Công nghệ màn hình	LED backlit LCD
Độ phân giải	2224 x 1668 pixels
Kích thước màn hình	10.5"

Chụp ảnh & Quay phim

Camera sau	8 MP
Quay phim	Full HD 1080p (1920 x 1080 pixels), Full HD 1080p@30fps
Tính năng camera	Chế độ làm đẹp, Tự động lấy nét, Chạm lấy nét, Nhận diện khuôn mặt, Nhận diện nụ cười, HDR, Panorama
Camera trước	7 MP

Cấu hình

Hệ điều hành	iOS 12
Loại CPU (Chipset)	Apple A12 Bionic 6 nhân
Tốc độ CPU	2 nhân 2.5 GHz & 4 nhân 1.6 GHz
Chip đồ hoạ (GPU)	Apple GPU 4 nhân
RAM	3 GB
Bộ nhớ trong (ROM)	64 GB
Bộ nhớ khả dụng	54 GB
Thẻ nhớ ngoài	Không
Hỗ trợ thẻ tối đa	Không
Cảm biến	Rung, Tiệm cận, La bàn, Con quay hồi chuyển 3 chiều, Khí áp kế, Gia tốc, Ánh sáng

Kết nối

Số khe SIM	Không
Loại SIM	Không
Thực hiện cuộc gọi	FaceTime
Hỗ trợ 3G	Không 3G
Hỗ trợ 4G	Không hỗ trợ 4G
WiFi	Wi-Fi 802.11 b/g/n
Bluetooth	5.0
GPS	A-GPS
Cổng kết nối/sạc	Lightning
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Không
Kết nối khác	Không

Chức năng khác

Ghi âm	Có
Radio	Không
Tính năng đặc biệt	Mở khóa bằng vân tay, Gọi điện FaceTime, Hỗ trợ bàn phím rời

Thiết kế & Trọng lượng

Chất liệu	Kim loại nguyên khối
Kích thước	Dài 250 mm - Rộng 174 mm - Dày 6.1 mm
Trọng lượng	456 g

Pin & Dung lượng

Loại pin	Lithium - Polymer
Mức năng lượng tiêu thụ', null, 0, 13990000, 100000, 1, '2019-12-24 12:57:00');
INSERT INTO product VALUES (74, 8, 1, null, 'Masstel Tab 10 Pro', 2590000, '2019-12-24 12:00:00', '2020-01-5 1:33:00', 'Màn hình

Công nghệ màn hình	IPS LCD
Độ phân giải	1280 x 800 pixels
Kích thước màn hình	10.1"

Chụp ảnh & Quay phim

Camera sau	5 MP
Quay phim	Có quay phim
Tính năng camera	Đèn Flash, Tự động lấy nét
Camera trước	2 MP

Cấu hình

Hệ điều hành	Android 9.0 (Pie)
Loại CPU (Chipset)	MediaTek MT6580 4 nhân
Tốc độ CPU	1.3 GHz
Chip đồ hoạ (GPU)	Mali-400
RAM	2 GB
Bộ nhớ trong (ROM)	16 GB
Bộ nhớ khả dụng	Khoảng 10 GB
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	32 GB
Cảm biến	Tiệm cận

Kết nối

Số khe SIM	2 SIM
Loại SIM	SIM thường
Thực hiện cuộc gọi	Có
Hỗ trợ 3G	Có 3G
Hỗ trợ 4G	Không hỗ trợ 4G
WiFi	Có
Bluetooth	Có
GPS	GPS
Cổng kết nối/sạc	Micro USB
Jack tai nghe	3.5 mm
Hỗ trợ OTG	Có
Kết nối khác	OTG

Chức năng khác

Ghi âm	Có
Radio	Có
Tính năng đặc biệt	Không

Thiết kế & Trọng lượng

Chất liệu	Nhựa + Kim loại
Kích thước	Dài 250 mm - Ngang 160 mm - Dày 9 mm
Trọng lượng	550.5 g

Pin & Dung lượng

Loại pin	Lithium - Polymer
Dung lượng pin	5000 mAh', null, 0, 2590000, 100000, 1, '2019-12-24 12:58:00');
INSERT INTO product VALUES (75, 8, 1, null, 'Samsung Galaxy Tab S6', 18490000, '2019-12-24 12:00:00', '2020-01-2 1:52:00', 'Màn hình

Công nghệ màn hình	Super AMOLED
Độ phân giải	2560 x 1600 pixels
Kích thước màn hình	10.5"

Chụp ảnh & Quay phim

Camera sau	Chính 13 MP & Phụ 5 MP
Quay phim	Ultra HD@30fps
Tính năng camera	Chế độ làm đẹp, Chụp hình góc rộng, Chụp hình góc siêu rộng, Tự động lấy nét, Chạm lấy nét, Nhận diện khuôn mặt, HDR, Panorama
Camera trước	8 MP

Cấu hình

Hệ điều hành	Android 9.0 (Pie)
Loại CPU (Chipset)	Snapdragon 855 8 nhân
Tốc độ CPU	1 nhân 2.84 GHz, 3 nhân 2.41 GHz & 4 nhân 1.78 GHz
Chip đồ hoạ (GPU)	Adreno 640
RAM	6 GB
Bộ nhớ trong (ROM)	128 GB
Bộ nhớ khả dụng	Đang cập nhật
Thẻ nhớ ngoài	Micro SD
Hỗ trợ thẻ tối đa	512 GB
Cảm biến	Rung, Gia tốc, Ánh sáng

Kết nối

Số khe SIM	1 SIM
Loại SIM	Nano Sim
Thực hiện cuộc gọi	Có
Hỗ trợ 3G	Có 3G
Hỗ trợ 4G	4G LTE
WiFi	Wi-Fi 802.11 a/b/g/n/ac, Wi-Fi Direct, Dual-band, Wi-Fi hotspot
Bluetooth	LE, A2DP, 5.0
GPS	GPS, GLONASS
Cổng kết nối/sạc	USB Type-C
Jack tai nghe	Không
Hỗ trợ OTG	Có
Kết nối khác	OTG

Chức năng khác

Ghi âm	Có
Radio	Không
Tính năng đặc biệt	Dolby Atmos, Hỗ trợ bút S Pen, Sạc pin nhanh, Âm thanh AKG, Mở khoá vân tay dưới màn hình, Samsung DeX

Thiết kế & Trọng lượng

Chất liệu	Kim loại
Kích thước	Dài 244.5 mm - Ngang 159.5 mm - Dày 5.7 mm
Trọng lượng	420 g

Pin & Dung lượng

Loại pin	Li-Po
Dung lượng pin	7040 mAh', null, 0, 18490000, 100000, 1, '2019-12-24 12:59:00');
INSERT INTO product VALUES (76, 4, 1, null, 'Huawei Watch GT2 46mm', 6990000, '2019-12-24 12:00:00', '2020-01-13 2:22:00', 'Màn hình

Công nghệ màn hình	AMOLED
Kích thước màn hình	1.39 inch
Độ phân giải	454 x 454 pixels
Chất liệu mặt	Kính cường lực
Đường kính mặt	46 mm

Cấu hình

CPU	Kirin A1
Bộ nhớ trong	2 GB
Hệ điều hành	LiteOS
Kết nối được với hệ điều hành	Android 4.4 trở lên, iOS 9 trở lên
Cổng sạc	Đế sạc nam châm

Pin

Thời gian sử dụng pin	Khoảng 30 giờ khi sử dụng GPS, Khoảng 14 ngày
Thời gian sạc	Đang cập nhật
Dung lượng pin	Đang cập nhật

Tiện ích & kết nối

Theo dõi sức khỏe	Theo dõi giấc ngủ, Đo nhịp tim, Tính lượng Calories tiêu thụ, Đếm số bước chân, Tính quãng đường chạy, Chế độ luyện tập
Hiển thị thông báo	Cuộc gọi, Nội dung tin nhắn, Zalo, Line, Viber
Tiện ích khác	Nghe nhạc với tai nghe Bluetooth, Màn hình luôn hiển thị, Gọi điện trên đồng hồ, Từ chối cuộc gọi, Dự báo thời tiết, La bàn, Thay mặt đồng hồ, Nhận cuộc gọi, Tìm điện thoại
Kết nối	Bluetooth v5.1, GPS
Camera	Không có

Dây đeo

Độ dài dây	Đang cập nhật
Độ rộng dây	2.2 cm
Chất liệu dây	Da
Dây có thể tháo rời	Có

Thông tin khác

Chất liệu khung viền	Thép không gỉ
Ngôn ngữ	Tiếng Anh, Tiếng Việt
Kích thước	Đang cập nhật
Trọng lượng	41 gram', null, 0, 6990000, 100000, 1, '2019-12-24 13:00:00');
INSERT INTO product VALUES (77, 4, 1, null, 'Xiaomi Amazfit Bip', 1400000, '2019-12-24 12:00:00', '2020-01-1 13:41:00', 'Màn hình

Công nghệ màn hình	Transflective LCD
Kích thước màn hình	1.28 inch
Độ phân giải	176 x 176 pixels
Chất liệu mặt	Kính cường lực Gorilla Class 3
Đường kính mặt	31.1 mm

Cấu hình

CPU	1.2 GHz Dual Core - M200S
Bộ nhớ trong	Đang cập nhật
Hệ điều hành	Đang cập nhật
Kết nối được với hệ điều hành	iOS, Android 4.4 trở lên
Cổng sạc	Đế sạc nam châm

Pin

Thời gian sử dụng pin	Khoảng 45 ngày, Khoảng 22 giờ khi sử dụng GPS
Thời gian sạc	Khoảng 2 giờ
Dung lượng pin	190 mAh

Tiện ích & kết nối

Theo dõi sức khỏe	Theo dõi giấc ngủ, Đo nhịp tim, Tính lượng Calories tiêu thụ, Đếm số bước chân, Tính quãng đường chạy, Chế độ luyện tập
Hiển thị thông báo	Cuộc gọi, Nội dung tin nhắn, Tin nhắn, Zalo, Messenger (Facebook), Line, Viber
Tiện ích khác	Báo thức, Màn hình luôn hiển thị, Từ chối cuộc gọi, Đồng hồ bấm giờ, Rung thông báo, Thay mặt đồng hồ
Kết nối	Bluetooth v4.0, GPS
Camera	Không có

Dây đeo

Độ dài dây	Đang cập nhật
Độ rộng dây	2 cm
Chất liệu dây	Silicone
Dây có thể tháo rời	Có

Thông tin khác

Chất liệu khung viền	Nhựa
Ngôn ngữ	Tiếng Anh, Ứng dụng tiếng Anh, Ứng dụng tiếng Việt
Kích thước	Dài 3.2 cm - Rộng 3.1 cm - Dày 1.1 cm
Trọng lượng	32g', null, 0, 1400000, 100000, 1, '2019-12-24 13:01:00');
INSERT INTO product VALUES (78, 4, 1, null, 'Samsung Galaxy Watch Active R500', 4490000, '2019-12-24 12:00:00', '2020-01-11 0:5:00', 'Màn hình

Công nghệ màn hình	AMOLED
Kích thước màn hình	1.1 inch
Độ phân giải	360 x 360 pixels
Chất liệu mặt	Kính cường lực Gorilla Class 3
Đường kính mặt	40 mm

Cấu hình

CPU	Exynos 9110
Bộ nhớ trong	4 GB
Hệ điều hành	OS TIZEN
Kết nối được với hệ điều hành	iOS 10 trở lên, Android 5.0
Cổng sạc	Đế sạc nam châm

Pin

Thời gian sử dụng pin	Khoảng 5 ngày
Thời gian sạc	Khoảng 2 giờ
Dung lượng pin	270 mAh

Tiện ích & kết nối

Theo dõi sức khỏe	Theo dõi giấc ngủ, Đo nhịp tim, Tính lượng Calories tiêu thụ, Đếm số bước chân, Tính quãng đường chạy, Chế độ luyện tập
Hiển thị thông báo	Cuộc gọi, Nội dung tin nhắn, Tin nhắn, Zalo, Messenger (Facebook), Line, Viber
Tiện ích khác	Báo thức, Nghe nhạc với tai nghe Bluetooth, Màn hình luôn hiển thị, Đồng hồ bấm giờ, Điều khiển chơi nhạc, Rung thông báo, Thay mặt đồng hồ
Kết nối	Bluetooth v4.2
Camera	Không có

Dây đeo

Độ dài dây	22.6 cm
Độ rộng dây	2 cm
Chất liệu dây	Silicone
Dây có thể tháo rời	Có

Thông tin khác

Chất liệu khung viền	Nhôm
Ngôn ngữ	Tiếng Anh, Tiếng Việt
Kích thước	Dài 39.5 mm - Rộng 39.5 mm -Dày 10.5 mm
Trọng lượng	25 g', null, 0, 4490000, 100000, 1, '2019-12-24 13:02:00');
INSERT INTO product VALUES (79, 4, 1, null, 'Apple Watch S5 44mm', 11990000, '2019-12-24 12:00:00', '2020-01-9 6:42:00', 'Màn hình

Công nghệ màn hình	OLED
Kích thước màn hình	1.78 inch
Độ phân giải	448 x 368 pixels
Chất liệu mặt	Ion-X strengthened glass
Đường kính mặt	44 mm

Cấu hình

CPU	Apple S5 64 bit
Bộ nhớ trong	32 GB
Hệ điều hành	watchOS 6.0
Kết nối được với hệ điều hành	iOS 13 trở lên
Cổng sạc	Đế sạc nam châm

Pin

Thời gian sử dụng pin	Khoảng 18 giờ
Thời gian sạc	Khoảng 2 giờ
Dung lượng pin	Đang cập nhật

Tiện ích & kết nối

Theo dõi sức khỏe	Đo nhịp tim, Tính lượng Calories tiêu thụ, Đếm số bước chân, Tính quãng đường chạy, Chế độ luyện tập
Hiển thị thông báo	Cuộc gọi, Nội dung tin nhắn, Tin nhắn, Zalo, Messenger (Facebook), Line, Viber
Tiện ích khác	Phát hiện té ngã, Báo thức, Nghe nhạc với tai nghe Bluetooth, Gọi điện trên đồng hồ, Từ chối cuộc gọi, Dự báo thời tiết, La bàn, Điều khiển chơi nhạc, Thay mặt đồng hồ
Kết nối	Wifi, Bluetooth v5.0, GPS
Camera	Không có

Dây đeo

Độ dài dây	Đang cập nhật
Độ rộng dây	Đang cập nhật
Chất liệu dây	Silicone
Dây có thể tháo rời	Có

Thông tin khác

Chất liệu khung viền	Nhôm
Ngôn ngữ	Tiếng Anh, Tiếng Việt
Kích thước	Đường kính 44 mm - Dày 10.7 mm
Trọng lượng	36.7 gram', null, 0, 11990000, 100000, 1, '2019-12-24 13:03:00');
INSERT INTO product VALUES (80, 4, 1, null, 'Zeblaze Plug C', 290000, '2019-12-24 12:00:00', '2020-01-8 9:24:00', 'Màn hình

Công nghệ màn hình	Transflective LCD
Kích thước màn hình	0.85 inch
Độ phân giải	72 x 144 pixels
Chất liệu mặt	Kính cường lực
Đường kính mặt	18.8 mm

Cấu hình

CPU	Đang cập nhật
Bộ nhớ trong	Không có
Hệ điều hành	Không có
Kết nối được với hệ điều hành	iOS 8 trở lên, Android 4.4 trở lên
Cổng sạc	Cổng sạc USB trên thân vòng đeo tay

Pin

Thời gian sử dụng pin	Khoảng 7 ngày
Thời gian sạc	Khoảng 1.5 giờ
Dung lượng pin	90 mAh

Tiện ích & kết nối

Theo dõi sức khỏe	Theo dõi giấc ngủ, Đo nhịp tim, Tính lượng Calories tiêu thụ, Đếm số bước chân, Chế độ luyện tập
Hiển thị thông báo	Cuộc gọi, Tin nhắn, Zalo, Line
Tiện ích khác	Màn hình luôn hiển thị, Đồng hồ bấm giờ, Tìm điện thoại, Nhắc nhở
Kết nối	Bluetooth
Camera	

Dây đeo

Độ dài dây	19.5 cm
Độ rộng dây	1.5 cm
Chất liệu dây	Silicone
Dây có thể tháo rời	Có

Thông tin khác

Ngôn ngữ	Tiếng Anh, Ứng dụng tiếng Anh
Kích thước	45.6 mm - 18.8 mm - 12.5 mm
Trọng lượng	70 g', null, 0, 290000, 100000, 1, '2019-12-24 13:04:00');


COMMIT;


INSERT INTO image VALUES(46, 'samsung-rt22m4032dx-sv-1-org.jpg', 'zZAPbr3Jr1zpS3QGsAqsE5JalOOrVFoc.jpg', 16);
INSERT INTO image VALUES(47, 'samsung-rt22m4032dx-sv-2-org.jpg', 'MF0gcR17kpoNov-Z67qTY6wejeMXgmWy.jpg', 16);
INSERT INTO image VALUES(48, 'samsung-rt22m4032dx-sv-3-org.jpg', 'VBVBoKXlzwV945npaaXQYvInTkrdMQ9M.jpg', 16);
INSERT INTO image VALUES(49, 'samsung-rt22m4032dx-sv-4-org.jpg', '4pGnkx-UvKcmUxyFwChx8S3UnoUhgF1O.jpg', 16);
INSERT INTO image VALUES(50, 'samsung-rt22m4032dx-sv-5-org.jpg', 'U3peInAcyK6VwzJx6I8H8PjxsThNGwcJ.jpg', 16);
INSERT INTO image VALUES(51, 'samsung-rt22m4032dx-sv-6-org.jpg', 'AMK9j7ygM0acSmPoDiZly69WdLH3bdlO.jpg', 16);
INSERT INTO image VALUES(52, 'tu-lanh-panasonic-nr-ba228pkv1-1-1-org.jpg', 'rHrunstEuKIbTrewaOeijzLWxTfhO97C.jpg', 17);
INSERT INTO image VALUES(53, 'tu-lanh-panasonic-nr-ba228pkv1-2-1-org.jpg', 'vOtEeHWuCshuAkqgV6rGzRsRh9DF-cA4.jpg', 17);
INSERT INTO image VALUES(54, 'tu-lanh-panasonic-nr-ba228pkv1-3-1-org.jpg', '8uiUbqvICch5UE6joQ7Bo3w1sJmvzDJ5.jpg', 17);
INSERT INTO image VALUES(55, 'tu-lanh-panasonic-nr-ba228pkv1-4-1-org.jpg', 'TxPitj9WblZQkJOz7l7h2LAx7D2ZDhQD.jpg', 17);
INSERT INTO image VALUES(56, 'samsung-rt32k5930dx-sv-1-org.jpg', 'LwsUn2OxyDGuHPzt6M4LuClVWMezrx4Q.jpg', 18);
INSERT INTO image VALUES(57, 'samsung-rt32k5930dx-sv-2-org.jpg', 'E2XV5UU5uvzjBPQycS8xdgvAyuQ8yXgN.jpg', 18);
INSERT INTO image VALUES(58, 'samsung-rt32k5930dx-sv-3-org.jpg', 'HqYNs4Z9pXPklfr9AHQfoBQJtEqzsXJw.jpg', 18);
INSERT INTO image VALUES(59, 'samsung-rt32k5930dx-sv-4-org.jpg', 'qE0fFvTtV1TZksgDDUC8qzaJUbgC-Qwm.jpg', 18);
INSERT INTO image VALUES(60, 'tu-lanh-samsung-rb30n4180b1-sv-1-1-org.jpg', '4-AYtKngdHGe6Kn9ihoJiZMzs8wmAOK4.jpg', 19);
INSERT INTO image VALUES(61, 'tu-lanh-samsung-rb30n4180b1-sv-2-1-org.jpg', 'aJ8pkwQ1pnDQN7tGFPWbGEFWLjeM-8jp.jpg', 19);
INSERT INTO image VALUES(62, 'tu-lanh-samsung-rb30n4180b1-sv-3-1-org.jpg', 'NXrsr52hvxw-gJhjWl9F-qxAl1nKbrUx.jpg', 19);
INSERT INTO image VALUES(63, 'tu-lanh-samsung-rb30n4180b1-sv-4-1-org.jpg', 'c989c5dI3APYQKwNHftVrDXZPkxXdMi8.jpg', 19);
INSERT INTO image VALUES(64, 'panasonic-nr-bl381wkvn-1-3-org.jpg', '4ihwgBZvG2MKoTsRKLzXdXkcW-UucXUv.jpg', 20);
INSERT INTO image VALUES(65, 'panasonic-nr-bl381wkvn-2-3-org.jpg', 'mZigW4SjhBYspHPYgsmE2eGOTReP8DRL.jpg', 20);
INSERT INTO image VALUES(66, 'panasonic-nr-bl381wkvn-3-3-org.jpg', 'Ipich0dxUDwX5Kf9q7yXbRRgDq7HzBXy.jpg', 20);
INSERT INTO image VALUES(67, 'tu-lanh-samsung-rt38k5982bs-sv-1-5-org.jpg', 'clNk5igol0Gr8ilbq5ECtYZZuhIDVAmU.jpg', 21);
INSERT INTO image VALUES(68, 'tu-lanh-samsung-rt38k5982bs-sv-2-5-org.jpg', 'E0EdWe0Laqh69BhC4WdjIqd2g0bUqZ1o.jpg', 21);
INSERT INTO image VALUES(69, 'tu-lanh-samsung-rt38k5982bs-sv-3-5-org.jpg', 'FN7k9DhsLjZd7ds0ZQ7FzEyTRLMvE9Oa.jpg', 21);
INSERT INTO image VALUES(70, 'toshiba-gr-a25vm-ukg-1-2-org.jpg', '1GItO1WMb9CcxIXqSGQeShOsIBZiqaQy.jpg', 22);
INSERT INTO image VALUES(71, 'toshiba-gr-a25vm-ukg-2-2-org.jpg', 'lKoIAiR6H4h1kySkewEFhu6407Q51FzT.jpg', 22);
INSERT INTO image VALUES(72, 'toshiba-gr-a25vm-ukg-3-1-org.jpg', 'eNA2jLT0vddBsPYtT1TAhfjNzuZAELJ1.jpg', 22);
INSERT INTO image VALUES(73, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-1-3-org.jpg', 'OrA8YtrQip0vH9EifTpx5Mm2tBtXb0OI.jpg', 24);
INSERT INTO image VALUES(74, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-10-2-org.jpg', 'ollgtYEQAmns0NeDaVankIdAfery9P7m.jpg', 24);
INSERT INTO image VALUES(75, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-11-2-org.jpg', 'hdTsHk2QC4KKYPvWEyRHoxsygHkWTKkF.jpg', 24);
INSERT INTO image VALUES(76, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-12-2-org.jpg', 'ZeKFM3Wtoh58l0XSX7p3pINjnPJ26Hkh.jpg', 24);
INSERT INTO image VALUES(77, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-13-5-org.jpg', '6l3daZsLxToYmN4P9ROvKKvKKWRwIEZ8.jpg', 24);
INSERT INTO image VALUES(78, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-2-2-org.jpg', 'WDxBRNStkb56D6pUvsRAEbS1-Svzd3ar.jpg', 24);
INSERT INTO image VALUES(79, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-3-3-org.jpg', '6Slb3T0aixFyNnjdzw2iJxZcNkRg9Y7O.jpg', 24);
INSERT INTO image VALUES(80, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-4-2-org.jpg', '8rNDxIGwOA0evxkjWt8Yxlw9bGFT50l1.jpg', 24);
INSERT INTO image VALUES(81, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-5-2-org.jpg', '5IYhmcSorwJe0s7vGEPTzF3WWYDuL80q.jpg', 24);
INSERT INTO image VALUES(82, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-6-2-org.jpg', 'ii2ADfvCpzLuiksZSkaOn0FNTmOccxyS.jpg', 24);
INSERT INTO image VALUES(83, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-7-2-org.jpg', 'uusV2KTdxUG1yhLENcijapkGeWEPmkf0.jpg', 24);
INSERT INTO image VALUES(84, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-8-2-org.jpg', 'QNSQ-6JTIWSI-J0J2U-Z0CtEQflECuFr.jpg', 24);
INSERT INTO image VALUES(85, 'apple-macbook-air-2019-i5-16ghz-8gb-128gb-mvfm2sa-9-2-org.jpg', 'lDosXOHfqfkkU-5g6qgOOSLTkrsLECcP.jpg', 24);
INSERT INTO image VALUES(86, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-1-org.jpg', 'c9kr1wm1wQQpZ5ez84KuJx6Lz4nR7bgO.jpg', 25);
INSERT INTO image VALUES(87, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-10-org.jpg', 'bPOAoJyfK0j3oPCN6OJKtnnvtRZohRg4.jpg', 25);
INSERT INTO image VALUES(88, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-11-org.jpg', 'zy4vi8tJZI7aezYDCNxnJBs-BuaXucJm.jpg', 25);
INSERT INTO image VALUES(89, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-12-org.jpg', '3Izp6yXdJu1PtWUSZiMyliwpYifZFbOd.jpg', 25);
INSERT INTO image VALUES(90, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-13-org.jpg', 'jFp7ZQ1w14BN9FY0xMfbeIKbxZHk8h5k.jpg', 25);
INSERT INTO image VALUES(91, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-14-org.jpg', 'Vllsdyxht24IQC2CQQmqgn-dgIz9e5rn.jpg', 25);
INSERT INTO image VALUES(92, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-15-org.jpg', 'cmoJRtWrSuEmUke6nNHwGqhbu8k6nQ4i.jpg', 25);
INSERT INTO image VALUES(93, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-16-org.jpg', 'xm3mVM2ywcwrPOPW8mrPFPEYpDufTQwb.jpg', 25);
INSERT INTO image VALUES(94, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-17-org.jpg', '8Jgx9oR7mrgaxLn-I8KbHrpfkLl9c7sF.jpg', 25);
INSERT INTO image VALUES(95, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-2-org.jpg', 'rsMr1ZtLG6VmjJMsQbWPiuhPutPwlXL1.jpg', 25);
INSERT INTO image VALUES(96, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-3-org.jpg', 'tVX-DM22o-m67fbAsXQq-86rlK-jjhm5.jpg', 25);
INSERT INTO image VALUES(97, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-4-org.jpg', 'CcwIJ-iwqFTpy0mzfxa6x3VtH-7eIDEi.jpg', 25);
INSERT INTO image VALUES(98, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-5-org.jpg', 'WkqJcjeVe5Hu1kZcCaiLGqEdP2Kz7KTK.jpg', 25);
INSERT INTO image VALUES(99, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-6-org.jpg', 'OV9PEwRq5R8xCwLZspw62upmgzC-HF06.jpg', 25);
INSERT INTO image VALUES(100, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-7-org.jpg', 'VYbRbB9lLKqsHhVfeR9B1gvz3j42Qzsn.jpg', 25);
INSERT INTO image VALUES(101, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-8-org.jpg', 'CVgdZOom7dmMsm205HCcctqr8Ulevz19.jpg', 25);
INSERT INTO image VALUES(102, 'lenovo-ideapad-s145-15iwl-i3-8145u-4gb-256gb-mx110-9-org.jpg', 'ohZuR69k25WQAEJAxlDvBOroAEFBCXui.jpg', 25);
INSERT INTO image VALUES(103, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-1-org.jpg', 'ijdzXHp8Fniu9m0KtYYYd3jrFgm70zvL.jpg', 26);
INSERT INTO image VALUES(104, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-10-org.jpg', 'jY9XzgiK-v8iNNIGykLtPJEnpVTLAOl-.jpg', 26);
INSERT INTO image VALUES(105, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-11-org.jpg', '66YjpW9YRHeJDfIujD-rWAV5nLb0QKlH.jpg', 26);
INSERT INTO image VALUES(106, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-12-org.jpg', 'N7YDUdyFNwZgDx2pQ0M11p9NB8pUESdJ.jpg', 26);
INSERT INTO image VALUES(107, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-13-org.jpg', 'cikFZ5-tnnFvbN10uoatoH7n01HnRRvc.jpg', 26);
INSERT INTO image VALUES(108, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-14-org.jpg', 'NHVpLUbLV5Oi-PGjjRjo0RlHMlc9QBgm.jpg', 26);
INSERT INTO image VALUES(109, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-15-org.jpg', '5PNv9tyvtx3dpyQtCduBXZ6oQwmtpqLy.jpg', 26);
INSERT INTO image VALUES(110, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-2-org.jpg', 'VGBRVgHxzBKmhdm3x1tp9nSpsdDDczNT.jpg', 26);
INSERT INTO image VALUES(111, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-3-org.jpg', 'gOHqIlM0B8rcKzdUjjwTBazMevLED-zJ.jpg', 26);
INSERT INTO image VALUES(112, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-4-org.jpg', 'O8EP3ix9dfJUTbh5yQohJ-mVmf5NZ7Gd.jpg', 26);
INSERT INTO image VALUES(113, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-5-org.jpg', 'nBiaDOrg9PJtUVlqS7eQf3gG1xMq4wrm.jpg', 26);
INSERT INTO image VALUES(114, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-6-org.jpg', 'gIGvnI1UPxEJIlqJ8sk5ox0J31epciT5.jpg', 26);
INSERT INTO image VALUES(115, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-7-org.jpg', 'Tk2MxW0IHoWyphCQ91ypev91dk8XHU73.jpg', 26);
INSERT INTO image VALUES(116, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-8-org.jpg', 'WtPgzLcI9zE3dGxzkDcf4f2Aq7UVUSgH.jpg', 26);
INSERT INTO image VALUES(117, 'acer-swift-sf315-52-38yq-i3-8130u-4gb-1tb-156f-win-9-org.jpg', 'MkfIUnb0KaO4uZmKJIud4leZjxc9A540.jpg', 26);
INSERT INTO image VALUES(118, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-1-1-org.jpg', 'ExUOViUuT5OTPHHKbHJY8nndlQNt5Qjl.jpg', 27);
INSERT INTO image VALUES(119, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-10-org.jpg', '9dJoLq5BhYkwRSkbGM0I-RjqPZ7vcgLb.jpg', 27);
INSERT INTO image VALUES(120, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-11-org.jpg', 'zOfYCQcNHEFnLFivAPyyyF56TtqMWUiF.jpg', 27);
INSERT INTO image VALUES(121, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-12-org.jpg', 'j3YkOkH8UOOkq6ZJGjGBvcgS-yVoydE1.jpg', 27);
INSERT INTO image VALUES(122, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-13-org.jpg', 'ZRgTBpbggTtDmlqmbV5E6Ir2nYy7falO.jpg', 27);
INSERT INTO image VALUES(123, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-14-org.jpg', 'weB65IxIbRRLl8DqlyPG1w-Va73TZz58.jpg', 27);
INSERT INTO image VALUES(124, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-15-org.jpg', 'cmFKEMXx61uVQDYxjwZdkWb-65OadwrX.jpg', 27);
INSERT INTO image VALUES(125, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-16-org.jpg', 'rCprX2W4bR40ePjRxZFDB8snMa9b9wEx.jpg', 27);
INSERT INTO image VALUES(126, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-2-org.jpg', 'R0PKSLFRjYsrNFFcC6aWzu46hJVHI5-F.jpg', 27);
INSERT INTO image VALUES(127, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-3-org.jpg', 'WDRx6w7IF1iON30Mb-mW6sqsp27CuKuG.jpg', 27);
INSERT INTO image VALUES(128, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-4-org.jpg', 'A8GpBshs-1oWwK0uVah9HlGwUScD6Y1Q.jpg', 27);
INSERT INTO image VALUES(129, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-5-org.jpg', 'lX9-nUv4DEFVHlbsSj42Yq6AIl-NbQN6.jpg', 27);
INSERT INTO image VALUES(130, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-6-org.jpg', '8YckSqK1cUxd8gVlI7Z-6-gibw4sgQOc.jpg', 27);
INSERT INTO image VALUES(131, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-7-org.jpg', 'TnSwip6PoMOBIRhgM80gTiEqYlNHDVxw.jpg', 27);
INSERT INTO image VALUES(132, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-8-org.jpg', 'XdrVqHTqtrGSRFJtTyu9pprWoBciUwVJ.jpg', 27);
INSERT INTO image VALUES(133, 'dell-vostro-5490-i5-10210u-8gb-256gb-win10-v4i510-9-org.jpg', 'r9Kdt57Obxoda9MLXSjLGdgLoE-iftgB.jpg', 27);
INSERT INTO image VALUES(134, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-1-1-org.jpg', 'cDknhsWyvK0G4cKQ7qwM2SZqazHyLeO6.jpg', 28);
INSERT INTO image VALUES(135, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-10-org.jpg', 'pYc7qvSy1ijbhD2z98txvfGtltZftcsQ.jpg', 28);
INSERT INTO image VALUES(136, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-11-org.jpg', 'RsjTWctotcsYvdW0ZBC6jUTCyrKvo6wp.jpg', 28);
INSERT INTO image VALUES(137, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-12-org.jpg', 'OXx3Q3aMSxRrmonU79Lmy2wCx4aB2EVU.jpg', 28);
INSERT INTO image VALUES(138, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-13-org.jpg', 'sWFebyjgcZR3XN9rYuiZZcCiyX8ORPBr.jpg', 28);
INSERT INTO image VALUES(139, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-14-org.jpg', 'aIoQ8tqgkE0R-T2p-9WPSIYbhVtpJDpo.jpg', 28);
INSERT INTO image VALUES(140, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-2-org.jpg', 'Yup9jab40XBLCSL5yom7oauRsyYtRhh-.jpg', 28);
INSERT INTO image VALUES(141, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-3-org.jpg', 'aCdagThRyZGyXhmRiKt41we-DGIPLiXo.jpg', 28);
INSERT INTO image VALUES(142, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-4-org.jpg', 'NX26wrGU0fnrYRoGvmhqyftE2G-m08jv.jpg', 28);
INSERT INTO image VALUES(143, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-5-org.jpg', 'dM1V1pYnAdb1iYkyIfaVjXSYMphS9Jwk.jpg', 28);
INSERT INTO image VALUES(144, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-6-org.jpg', 'I-72mHZWDTDTDi8ZDWb7A98yNzT4ynGJ.jpg', 28);
INSERT INTO image VALUES(145, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-7-org.jpg', 'F1SsG7ktiD474BBhIbGl1inOGV3SEXGA.jpg', 28);
INSERT INTO image VALUES(146, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-8-org.jpg', 'd32K5KODOViGiwSCEINUZeKaT78JPLsy.jpg', 28);
INSERT INTO image VALUES(147, 'msi-gaming-gf63-9sc-i7-9750h-8gb-256gb-gtx1650-win-9-org.jpg', 'tyT3Nkv6hYXxqUI4mKwEZHFay4HazYuV.jpg', 28);
INSERT INTO image VALUES(148, 'acer-aspire-a515-54g-51j3-i5-10210u-8gb-1tb-ssd-2g-1-1-org.jpg', 'dDQqr7FR6lFauyKtrtZKWL2BGWNgBWXX.jpg', 29);
INSERT INTO image VALUES(149, 'acer-aspire-a515-54g-51j3-i5-10210u-8gb-1tb-ssd-2g-2-1-org.jpg', 'EMtgHaLGFU-frOibFebB1CrgzyGxQO8V.jpg', 29);
INSERT INTO image VALUES(150, 'acer-aspire-a515-54g-51j3-i5-10210u-8gb-1tb-ssd-2g-3-1-org.jpg', 'tUYizuEaRZXjenzKiv6IFI4AYWo2CyyN.jpg', 29);
INSERT INTO image VALUES(151, 'lenovo-ideapad-c340-14iwl-i3-8145u-8gb-256gb-touch-1-org.jpg', 'ISqOUNNinibm9IYI4wy4VT6ZzSkppCdE.jpg', 30);
INSERT INTO image VALUES(152, 'lenovo-ideapad-c340-14iwl-i3-8145u-8gb-256gb-touch-2-org.jpg', 'BxzXXowS1VbCV32QOOwZ1jUC6cy5MTv3.jpg', 30);
INSERT INTO image VALUES(153, 'lenovo-ideapad-c340-14iwl-i3-8145u-8gb-256gb-touch-3-org.jpg', 'TGLlvw-sMdIwfhXK4QYRMI55wGhdRI7Z.jpg', 30);
INSERT INTO image VALUES(154, 'acer-swift-sf314-56-38ue-i3-8145u-4gb-256gb-win10-1-1-org.jpg', 'G5mqMWDqXwaFjC3pX524knMOT2l1FveV.jpg', 31);
INSERT INTO image VALUES(155, 'acer-swift-sf314-56-38ue-i3-8145u-4gb-256gb-win10-2-org.jpg', '1yyMXQB8PgzLlJ3icDUT4UJdFnEfpFbc.jpg', 31);
INSERT INTO image VALUES(156, 'acer-swift-sf314-56-38ue-i3-8145u-4gb-256gb-win10-3-org.jpg', 'BLJtSm9dZRXqX0vvFBAVOkTj8vzkGiMl.jpg', 31);
INSERT INTO image VALUES(157, 'acer-aspire-a515-53-5112-i5-8265u-4gb-16gb-1tb-win-1-1-org.jpg', 'cLWNNExaEjEimh6PbZgngP-KNrQOjoyy.jpg', 32);
INSERT INTO image VALUES(158, 'acer-aspire-a515-53-5112-i5-8265u-4gb-16gb-1tb-win-2-org.jpg', 'AyEh9--woxGdbj369sAcWNTtA0-k5fH9.jpg', 32);
INSERT INTO image VALUES(159, 'acer-aspire-a515-53-5112-i5-8265u-4gb-16gb-1tb-win-3-org.jpg', 'bt-sByYK0H05AQTkZfxOk3TGwESq0leC.jpg', 32);
INSERT INTO image VALUES(160, 'dell-inspiron-5584-i5-8265u-8gb-1tb-156f-win10-cx-1-org.jpg', 'qGUPGIGrAF5z1quLjcRXAEcn5a2nacvt.jpg', 33);
INSERT INTO image VALUES(161, 'dell-inspiron-5584-i5-8265u-8gb-1tb-156f-win10-cx-2-org.jpg', 'c2kw7J4hGI7vgJzPzkmpmkVeMcGqsAl1.jpg', 33);
INSERT INTO image VALUES(162, 'dell-inspiron-5584-i5-8265u-8gb-1tb-156f-win10-cx-3-org.jpg', 'WTQKlMejZfM4b7JGzmCOSK3MEK8tmajh.jpg', 33);
INSERT INTO image VALUES(163, 'dell-inspiron-3579-i5-8300h-8gb-1tb-128gb-gtx1050t-1-2-org.jpg', 'F7885QYq7-O1POPm8J9T0w072MgwMVjf.jpg', 34);
INSERT INTO image VALUES(164, 'dell-inspiron-3579-i5-8300h-8gb-1tb-128gb-gtx1050t-2-1-org.jpg', 'chiAJKTpoL-encesCX5mUAeQoZchdbYC.jpg', 34);
INSERT INTO image VALUES(165, 'dell-inspiron-3579-i5-8300h-8gb-1tb-128gb-gtx1050t-3-2-org.jpg', 'FcOv3KgSmVcbxg8B6BZWkhlP4be3AykS.jpg', 34);
INSERT INTO image VALUES(166, 'acer-aspire-a315-42-r8px-r3-3200u-8gb-256gb-win10-1-org.jpg', 'kelW7xVjt3zBMeXzrtxOf5ldwCTcQktd.jpg', 36);
INSERT INTO image VALUES(167, 'acer-aspire-a315-42-r8px-r3-3200u-8gb-256gb-win10-2-org.jpg', 'x1JlzKRP0QOfEEHE1M27c645GLMqiIRL.jpg', 36);
INSERT INTO image VALUES(168, 'acer-aspire-a315-42-r8px-r3-3200u-8gb-256gb-win10-3-org.jpg', 'Uox5OFmTF14gtrVX8g2XVP3-RWFI6Bxo.jpg', 36);
INSERT INTO image VALUES(169, 'dell-inspiron-3593-i7-1065g7-8gb-512gb-2gb-mx230-w-den-1-org.jpg', '7bPcItPLOuEMpb9YGBi8NYnblp8F0xi0.jpg', 37);
INSERT INTO image VALUES(170, 'dell-inspiron-3593-i7-1065g7-8gb-512gb-2gb-mx230-w-den-2-org.jpg', 'CiQqHoidccLGMWHPX2AQJXqn2juFXa3J.jpg', 37);
INSERT INTO image VALUES(171, 'dell-inspiron-3593-i7-1065g7-8gb-512gb-2gb-mx230-w-den-3-org.jpg', '3B-TKqw6GGNFibcWU6pL28jFb76bnU-j.jpg', 37);
INSERT INTO image VALUES(172, 'acer-spin-3-sp314-51-39wk-i3-7130u-nxguwsv001-360-1-org.jpg', 'cAPQ9-pCB06cQHqRYuj1RyuPgDSC3FsN.jpg', 38);
INSERT INTO image VALUES(173, 'acer-spin-3-sp314-51-39wk-i3-7130u-nxguwsv001-360-2-org.jpg', '9cTy0DcbdgfklhnlozSOOLIPBqNnMoeC.jpg', 38);
INSERT INTO image VALUES(174, 'acer-spin-3-sp314-51-39wk-i3-7130u-nxguwsv001-360-3-org.jpg', 'kIYnjzZQk58GP4gAgzUwLpgYWdcP76vs.jpg', 38);
INSERT INTO image VALUES(175, 'oppo-a5-2020-trang-3-org.jpg', 'GBSuzvn5YEuap0wHthgls7x0oyh0W3WV.jpg', 40);
INSERT INTO image VALUES(176, 'oppo-a5-2020-trang-4-org.jpg', '6sqqtpyZEJbV8jmQlBnPwv44X8ZOKRXM.jpg', 40);
INSERT INTO image VALUES(177, 'oppo-a5-2020-trang-5-org.jpg', 'IaBfqClaQFIk0Vo0bCDXRVDD2YI2yJBw.jpg', 40);
INSERT INTO image VALUES(178, 'oppo-a5-2020-trang-6-org.jpg', 'WDkeDNF9QLAsJx9DnfZk0rGvx9HxgnXx.jpg', 40);
INSERT INTO image VALUES(179, 'oppo-a5-2020-trang-7-org.jpg', '6urGEl0fJqReSyUhfIpHysqyHlb69WqE.jpg', 40);
INSERT INTO image VALUES(180, 'oppo-a5-2020-trang-8-org.jpg', 'Gl-y0tRnPjYo5Iw330OCx2UpnWB4EUXc.jpg', 40);
INSERT INTO image VALUES(181, 'oppo-a5-2020-trang-9-org.jpg', 'P7-H6TnXAuujhJU5ZJYI2DVPsORt5Hl5.jpg', 40);
INSERT INTO image VALUES(182, 'iphone-11-den-1-org.jpg', 'eC01e2cj8Ilv9xPHeExwd0x-kFLjEgo3.jpg', 41);
INSERT INTO image VALUES(183, 'iphone-11-den-2-org.jpg', 'Ty40IzNUPuzIHPHXHIQuzumnpD6d5HZA.jpg', 41);
INSERT INTO image VALUES(184, 'iphone-11-den-3-org.jpg', 'MmdKUB7CkbSl1f3vB1I-v-StsobWNG7-.jpg', 41);
INSERT INTO image VALUES(185, 'iphone-11-den-4-org.jpg', 'jPePf8p4BW2mULYJe80L2MxdaeU4iejP.jpg', 41);
INSERT INTO image VALUES(186, 'iphone-11-do-1-org.jpg', 'bK0-qnAhlFwSqT5XfXsooQqjDJFHO8tN.jpg', 41);
INSERT INTO image VALUES(187, 'iphone-11-do-2-org.jpg', 'Ye9BH4rCDKMGhbUkTuFEqr1unh5MLs6G.jpg', 41);
INSERT INTO image VALUES(188, 'iphone-11-do-3-org.jpg', 'QfhaeR5owAY62426tQYWnDiGgPU-URKt.jpg', 41);
INSERT INTO image VALUES(189, 'iphone-11-do-4-org.jpg', 'Vi-yssEIkY2H6tshJSOoKTkazHa9zC4T.jpg', 41);
INSERT INTO image VALUES(190, 'iphone-11-tim-1-org.jpg', 'ARQCvKGXtsNqMIpnEP8Prps5lNSHOlxF.jpg', 41);
INSERT INTO image VALUES(191, 'iphone-11-tim-2-org.jpg', 'WhWXBs4THfOzruT4wWYxt2E7WOMizfID.jpg', 41);
INSERT INTO image VALUES(192, 'iphone-11-tim-3-org.jpg', 'ALFq1no4q8ts492XKLu0CpB3UlRvUD03.jpg', 41);
INSERT INTO image VALUES(193, 'iphone-11-tim-4-org.jpg', 'A9VxJjHX0dMPIGfIW-eWNbphBOWzuwBl.jpg', 41);
INSERT INTO image VALUES(194, 'iphone-11-trang-1-org.jpg', 'ULQtyb7gAoR50B79MejVZxyDku9tD46i.jpg', 41);
INSERT INTO image VALUES(195, 'iphone-11-trang-2-org.jpg', '4gtt2aYF8v-sFbCZdXc0R4jHIk0uoPbI.jpg', 41);
INSERT INTO image VALUES(196, 'iphone-11-trang-3-org.jpg', 'YAhDlqmy4I6ijDydviDV7mDdp6Ky4uTv.jpg', 41);
INSERT INTO image VALUES(197, 'iphone-11-trang-4-org.jpg', 'Byqoi0IW8bX971bwZuta4bWvESbTkrna.jpg', 41);
INSERT INTO image VALUES(198, 'iphone-11-vang-1-org.jpg', 'bgEQ6z4eMZt3SeIKGKXoFswLTGO5RKU1.jpg', 41);
INSERT INTO image VALUES(199, 'iphone-11-vang-2-org.jpg', 'FAY5wT5fz9dBlYR0-HC5iU9Yt2OROj4P.jpg', 41);
INSERT INTO image VALUES(200, 'iphone-11-vang-3-org.jpg', 'cYf4b9FDR96TDsqxmqb9sfYGFPDfUp9U.jpg', 41);
INSERT INTO image VALUES(201, 'iphone-11-vang-4-org.jpg', 'lFMgIxtFSp8v2S2vuSuR7N6RBOq5X5gE.jpg', 41);
INSERT INTO image VALUES(202, 'iphone-11-xanh-1-org.jpg', 'apfY3lKd0qiXZRaq9ungqqn9hYGTJPvZ.jpg', 41);
INSERT INTO image VALUES(203, 'iphone-11-xanh-2-org.jpg', 'GxcIV2FHvOosQ7f6K4iwtqNGcmGjfeB2.jpg', 41);
INSERT INTO image VALUES(204, 'iphone-11-xanh-3-org.jpg', 'SKUoA6wfYaasfANMKkAYMbapn6zDMxgD.jpg', 41);
INSERT INTO image VALUES(205, 'iphone-11-xanh-4-org.jpg', '0I6uOcDgkTog3FZqGY8ErFnO6R-laSFO.jpg', 41);
INSERT INTO image VALUES(206, 'samsung-galaxy-s10-plus-512gb-den-1-org.jpg', '3cKRv76ul9jvIakyE16q2HlpHdn1YGZO.jpg', 42);
INSERT INTO image VALUES(207, 'samsung-galaxy-s10-plus-512gb-den-10-org.jpg', '1cjRi--N0wmKdsHeVf9eMikcXVi34C1Q.jpg', 42);
INSERT INTO image VALUES(208, 'samsung-galaxy-s10-plus-512gb-den-11-org.jpg', 'RCaniHuLMzHtnt6Qg5JxS3gr-nYtPmFV.jpg', 42);
INSERT INTO image VALUES(209, 'samsung-galaxy-s10-plus-512gb-den-12-org.jpg', 'OYncqmAaHEJg3-wlXQzaDR4sveS10BPK.jpg', 42);
INSERT INTO image VALUES(210, 'samsung-galaxy-s10-plus-512gb-den-2-org.jpg', 'y6d8hMuay2vNf5BARxjjoHYC19hPiXHu.jpg', 42);
INSERT INTO image VALUES(211, 'samsung-galaxy-s10-plus-512gb-den-3-org.jpg', '1UXgOm1yCPeLDJKoQ5ccC1cLzwcxl0LX.jpg', 42);
INSERT INTO image VALUES(212, 'samsung-galaxy-s10-plus-512gb-den-4-org.jpg', 'Rgxr6FnZBwBiXXluHbaQcZn0YzlEFoH4.jpg', 42);
INSERT INTO image VALUES(213, 'samsung-galaxy-s10-plus-512gb-den-5-org.jpg', 'EITU6mOUsRUytXRxTIBucAnUurjFSYza.jpg', 42);
INSERT INTO image VALUES(214, 'samsung-galaxy-s10-plus-512gb-den-6-org.jpg', 'Sj0b3m0mzrRk7qmFSWdoIbyLMFMmBsLn.jpg', 42);
INSERT INTO image VALUES(215, 'samsung-galaxy-s10-plus-512gb-den-7-org.jpg', '7FRdXIgywjOwruytdiQvk2-ypDZ4u4H5.jpg', 42);
INSERT INTO image VALUES(216, 'samsung-galaxy-s10-plus-512gb-den-8-org.jpg', 'M-17zclQDFXqTPeTmiOHNVIB5ALlZP6a.jpg', 42);
INSERT INTO image VALUES(217, 'samsung-galaxy-s10-plus-512gb-den-9-org.jpg', 'ICTESX-MWqKjfHNYg2U2VMzPgqjYHVgS.jpg', 42);
INSERT INTO image VALUES(218, 'blackberry-key2-den-1-2-org.jpg', '08wXbrvO4DskRXdxrMTwaNlKgwLhdXvl.jpg', 43);
INSERT INTO image VALUES(219, 'blackberry-key2-den-10-2-org.jpg', '1b-a-gxHOLKRc9xgVMsTa8n6xMDX5iBJ.jpg', 43);
INSERT INTO image VALUES(220, 'blackberry-key2-den-11-2-org.jpg', 'mfNQHZdIILPLoGHuuBg7b9G4nFeFUtJ6.jpg', 43);
INSERT INTO image VALUES(221, 'blackberry-key2-den-2-2-org.jpg', 'DybviwoyfU3-SutDA3sVC-3qCZ2vGWjO.jpg', 43);
INSERT INTO image VALUES(222, 'blackberry-key2-den-3-2-org.jpg', '4g-nYZCzKtJVotdrdT2r72Kbi6XrbYpC.jpg', 43);
INSERT INTO image VALUES(223, 'blackberry-key2-den-4-2-org.jpg', 'BZSo74CLuyoYcL3DHWvC9nhyLo2fQb28.jpg', 43);
INSERT INTO image VALUES(224, 'blackberry-key2-den-5-2-org.jpg', 'LPSR1KARv7x9Pfbuoi4q3ku5sXDU4nGX.jpg', 43);
INSERT INTO image VALUES(225, 'blackberry-key2-den-6-2-org.jpg', '5qabWi6ReFyQfhfIgwtXDx5dXo0P6ksf.jpg', 43);
INSERT INTO image VALUES(226, 'blackberry-key2-den-7-2-org.jpg', '7iuCU2YsEusY4nD2biqlViZu8grR0iBT.jpg', 43);
INSERT INTO image VALUES(227, 'blackberry-key2-den-8-2-org.jpg', 'GbBVvNHP5Nwa1eTJYJEeCQTS-KHQSSn-.jpg', 43);
INSERT INTO image VALUES(228, 'blackberry-key2-den-9-2-org.jpg', 'DrIQ9ZyJcvKHxAZzpuGHXJa6hG3zm3C7.jpg', 43);
INSERT INTO image VALUES(229, 'xiaomi-mi-note-10-pro-den-1-org.jpg', '0vzxVq4xSFaW3lh0eatJEipDiWwsMSku.jpg', 44);
INSERT INTO image VALUES(230, 'xiaomi-mi-note-10-pro-den-10-org.jpg', 'VbeAnAjfcYcM3Bbd2deZDH2P2wqSD4fE.jpg', 44);
INSERT INTO image VALUES(231, 'xiaomi-mi-note-10-pro-den-11-org.jpg', '0vFSjvQNquql3ynC--PS-XMzq8vZMOE3.jpg', 44);
INSERT INTO image VALUES(232, 'xiaomi-mi-note-10-pro-den-12-org.jpg', 'aFG2FfdEwJ7NEJiPdNvDmbbKzLcGWwZY.jpg', 44);
INSERT INTO image VALUES(233, 'xiaomi-mi-note-10-pro-den-2-org.jpg', '4TRiEPHDCLz7QeOEkd5yuuEgYLShrSr0.jpg', 44);
INSERT INTO image VALUES(234, 'xiaomi-mi-note-10-pro-den-3-org.jpg', 'Wyy8i7NMaJav0rXqxD9NaQkRdN90R9gq.jpg', 44);
INSERT INTO image VALUES(235, 'xiaomi-mi-note-10-pro-den-4-org.jpg', 'rwweHVRjazOiq8SnRPZUy7Dv3hy0ReJl.jpg', 44);
INSERT INTO image VALUES(236, 'xiaomi-mi-note-10-pro-den-5-org.jpg', 'hlNYUCPmCR5Sb9ZGjwWTEMbv1uyexc9C.jpg', 44);
INSERT INTO image VALUES(237, 'xiaomi-mi-note-10-pro-den-6-org.jpg', 'BoAmHURmtKLGTrFBY-EbHnq-VHUWk17E.jpg', 44);
INSERT INTO image VALUES(238, 'xiaomi-mi-note-10-pro-den-7-org.jpg', 'CJiJedwfoSZef9GrE1L3Hls9z9NkSUm6.jpg', 44);
INSERT INTO image VALUES(239, 'xiaomi-mi-note-10-pro-den-8-org.jpg', 'w27pAe7gK98GPyOMyvZfHS9Bcd0et-xb.jpg', 44);
INSERT INTO image VALUES(240, 'xiaomi-mi-note-10-pro-den-9-org.jpg', 'KofAACZ3Z-MImSMwVdXtX3X4omlZBqa1.jpg', 44);
INSERT INTO image VALUES(241, 'xiaomi-mi-note-10-pro-xanh-la-1-org.jpg', 'JMTuFsEX8X9WOblOFBhz-ZCQmuqI1f58.jpg', 44);
INSERT INTO image VALUES(242, 'xiaomi-mi-note-10-pro-xanh-la-10-org.jpg', 'tus6m72vJxgTGgmGMRlGUdunth6vf221.jpg', 44);
INSERT INTO image VALUES(243, 'xiaomi-mi-note-10-pro-xanh-la-11-org.jpg', 'k4Qics2vh6hcxvQe7yvzqAKKyZVQk0Dl.jpg', 44);
INSERT INTO image VALUES(244, 'xiaomi-mi-note-10-pro-xanh-la-12-org.jpg', 'M6FZgA6rJSAx9XEhskhMrsz88BTEI7go.jpg', 44);
INSERT INTO image VALUES(245, 'xiaomi-mi-note-10-pro-xanh-la-2-org.jpg', 'iT7wBQW8AquSoL6EVyYashJjTWJDSNxB.jpg', 44);
INSERT INTO image VALUES(246, 'xiaomi-mi-note-10-pro-xanh-la-3-org.jpg', 'qGhKCOaekkBPfo9zYnMBoXokO9Yjez7w.jpg', 44);
INSERT INTO image VALUES(247, 'xiaomi-mi-note-10-pro-xanh-la-4-org.jpg', 'A4m0bBgYDZ1sf8F-Xcxn2SCoHNv7TsMO.jpg', 44);
INSERT INTO image VALUES(248, 'xiaomi-mi-note-10-pro-xanh-la-5-org.jpg', 'Ea4jOAWtVCVDjmYnb6UYDfUoQQa0Pqpm.jpg', 44);
INSERT INTO image VALUES(249, 'xiaomi-mi-note-10-pro-xanh-la-6-org.jpg', 'H3kENL56mo8JxOLQKwzcieV3KSCahe7c.jpg', 44);
INSERT INTO image VALUES(250, 'xiaomi-mi-note-10-pro-xanh-la-7-org.jpg', 'jGCl4fiWrCLY4ZflyG5jlqy1QQB2iyny.jpg', 44);
INSERT INTO image VALUES(251, 'xiaomi-mi-note-10-pro-xanh-la-8-org.jpg', 'ou4NooCcZ8Wo-HZRiVDNv7RgFZlw7jJL.jpg', 44);
INSERT INTO image VALUES(252, 'xiaomi-mi-note-10-pro-xanh-la-9-org.jpg', 'JggE0e87mvTcd-bY7ktREblXYlYtHBN9.jpg', 44);
INSERT INTO image VALUES(253, 'xiaomi-redmi-7-do-1-org.jpg', 'SDqSbzBnKioGe9NzRuExfckm3Rv81LyB.jpg', 45);
INSERT INTO image VALUES(254, 'xiaomi-redmi-7-do-2-org.jpg', 'iteMKLhkuT0uXW7RSWN-LIsWgRDROzrl.jpg', 45);
INSERT INTO image VALUES(255, 'xiaomi-redmi-7-do-3-org.jpg', 'p9x2a0bA5UJjcTs3xnIJLdKCbY07wdCO.jpg', 45);
INSERT INTO image VALUES(256, 'samsung-galaxy-a10s-xanh-1-1-org.jpg', 'SSLSTC7MEO9A81i5Zj2cqhmKNVykIMuo.jpg', 46);
INSERT INTO image VALUES(257, 'samsung-galaxy-a10s-xanh-2-1-org.jpg', 'OFoMRb8mEX7609SRkcF41kCE0x9s8RgK.jpg', 46);
INSERT INTO image VALUES(258, 'samsung-galaxy-a10s-xanh-3-1-org.jpg', 'VnWML7WW9XqgEvNE06u5xlZ629gPuGeX.jpg', 46);
INSERT INTO image VALUES(259, 'vsmart-live-6gb-den-1-org.jpg', 'Rm53tDm6tP8spNZC10erQG-ozAPEM5A2.jpg', 47);
INSERT INTO image VALUES(260, 'vsmart-live-6gb-den-2-org.jpg', 'gr87yW1X6yaZR9GnK7x1hXskJ8m1VH98.jpg', 47);
INSERT INTO image VALUES(261, 'vsmart-live-6gb-den-3-org.jpg', 'EE395XgmhZEr0UJ8EZlH96sQqpOfLZsH.jpg', 47);
INSERT INTO image VALUES(262, 'nokia-61-plus-den-1-org.jpg', 'DESJdXnfogms3hQOmhWZpoRCreNAmLUt.jpg', 48);
INSERT INTO image VALUES(263, 'nokia-61-plus-den-2-org.jpg', 'u4t248JJbdoOouMAKAspThw01DCcJeoR.jpg', 48);
INSERT INTO image VALUES(264, 'nokia-61-plus-den-3-org.jpg', 'MJ7DOP8pd34Vtg95g7sGbe45FBqG8UAF.jpg', 48);
INSERT INTO image VALUES(265, 'realme-3-xanh-la-1-org.jpg', '3nSs89GyPXhOOUyDWnpQjHxeB9dF0jp7.jpg', 49);
INSERT INTO image VALUES(266, 'realme-3-xanh-la-2-org.jpg', 'iItaWYM9n2DNJXaYaChy7Msn4XMvzLx1.jpg', 49);
INSERT INTO image VALUES(267, 'realme-3-xanh-la-3-org.jpg', 'Vjp6dKm4b2i2hAHBQUCzCyiTIWxVgAUD.jpg', 49);
INSERT INTO image VALUES(268, 'xiaomi-redmi-note-8-32gb-trang-1-org.jpg', 'fcnyZfWsB2Agg-J3NNjb1Mzo5yKDfUDV.jpg', 50);
INSERT INTO image VALUES(269, 'xiaomi-redmi-note-8-32gb-trang-2-org.jpg', 'g82nBgKFRN1fociqwrImbDaP9oBKBlzQ.jpg', 50);
INSERT INTO image VALUES(270, 'xiaomi-redmi-note-8-32gb-trang-3-org.jpg', 'Ue7HOHUPDn-HKEX0Q6LdiH3e8qfF0S7d.jpg', 50);
INSERT INTO image VALUES(271, 'realme-5-tim-1-org.jpg', 'LubCLncHLVnfHG6f9acW-UM5URpUX8O-.jpg', 51);
INSERT INTO image VALUES(272, 'realme-5-tim-2-org.jpg', 'ke9m6s1emBnNkhc00zvaBhwvIUTHtdmx.jpg', 51);
INSERT INTO image VALUES(273, 'realme-5-tim-3-org.jpg', '7w4OAKn4hjFLGBwG1WmMTIuCJFKhXEad.jpg', 51);
INSERT INTO image VALUES(274, 'samsung-galaxy-a20-do-1-org.jpg', '8ZV5cRoDtEoibu7LJiYKPibrc1DzieJ8.jpg', 52);
INSERT INTO image VALUES(275, 'samsung-galaxy-a20-do-2-org.jpg', 'KhmXR8u2VPw2qzAFpZLqeAd3T3MyE53G.jpg', 52);
INSERT INTO image VALUES(276, 'samsung-galaxy-a20-do-3-org.jpg', 'v9kZpF6wlENIBVA9trhDkacKyQORtiCH.jpg', 52);
INSERT INTO image VALUES(277, 'vivo-y17-xanh-1-org.jpg', '1SIUl1-tw5-viZXCbxbPjKVCpa4xXMfV.jpg', 53);
INSERT INTO image VALUES(278, 'vivo-y17-xanh-2-org.jpg', 'Xt9EXPxB4KP5USOlIxwxerRqHJ1Si2iO.jpg', 53);
INSERT INTO image VALUES(279, 'vivo-y17-xanh-3-org.jpg', 'stSgucp8UqSMz18p9b11gL5dDGJCfgNk.jpg', 53);
INSERT INTO image VALUES(280, 'samsung-galaxy-a20s-32gb-do-1-org.jpg', 'eNuP71BHx1D1eE4v7pTc96H20nn7m2D2.jpg', 54);
INSERT INTO image VALUES(281, 'samsung-galaxy-a20s-32gb-do-2-org.jpg', 'aVE5U1dYiubWEICTtkm8Yn5JGHrkUT0g.jpg', 54);
INSERT INTO image VALUES(282, 'samsung-galaxy-a20s-32gb-do-3-org.jpg', 'zMW1cAFVeQ2KLujHCQY4ciDSuUvwnDav.jpg', 54);
INSERT INTO image VALUES(283, 'mobell-nova-p3-tim-1-org.jpg', 'GYCt12gwAVkVe1prM7AelaUEeO9blEnz.jpg', 55);
INSERT INTO image VALUES(284, 'mobell-nova-p3-tim-2-org.jpg', 'P86SToODne3eJ-iQXzwwCCPDF-y6NHlT.jpg', 55);
INSERT INTO image VALUES(285, 'mobell-nova-p3-tim-3-org.jpg', 'iZcptosykK0oBAJOgxovwUEyGHdr9fyP.jpg', 55);
INSERT INTO image VALUES(286, 'sac-du-phong-polymer-10000mah-xiaomi-mi-18w-trang-1-org.jpg', '479u9ZS8ExrI8M7CgPzhS6Emv0mMqt8j.jpg', 56);
INSERT INTO image VALUES(287, 'sac-du-phong-polymer-10000mah-xiaomi-mi-18w-trang-2-org.jpg', 'EfuBVcw9N4K5ebUdrVxdv2z7EKOjFQA0.jpg', 56);
INSERT INTO image VALUES(288, 'sac-du-phong-polymer-10000mah-xiaomi-mi-18w-trang-3-org.jpg', 'N3BowvT2gJ32wd1d-yi3haE1wvzGKQPa.jpg', 56);
INSERT INTO image VALUES(289, 'sac-du-phong-polymer-10000mah-xiaomi-mi-18w-trang-4-org.jpg', 'zToFqMz-ou021t7oK0j9dHbnCcTS2skN.jpg', 56);
INSERT INTO image VALUES(290, 'pin-du-phong-c-wireless-energizer-qc10000gy-xam-1-3-org.jpg', 'zmlWDvC819Ps5vRW6YoE-zm9Qr6qd9IR.jpg', 57);
INSERT INTO image VALUES(291, 'pin-du-phong-c-wireless-energizer-qc10000gy-xam-2-3-org.jpg', 'NPG3qaQDQw427Avtk429lQ7F4Srtykzt.jpg', 57);
INSERT INTO image VALUES(292, 'pin-du-phong-c-wireless-energizer-qc10000gy-xam-4-3-org.jpg', 'Pm-m7U1Yi3KdSyfwkhwHhqipxDtjIVA3.jpg', 57);
INSERT INTO image VALUES(293, 'tai-nghe-bluetooth-tws-huawei-freebuds-3-den-1-org.jpg', 'fcp4gsQpnFZIfGtI2IunJpTiWjBQCmQ7.jpg', 58);
INSERT INTO image VALUES(294, 'tai-nghe-bluetooth-tws-huawei-freebuds-3-den-2-org.jpg', 'MsZU5XVphsrK61YyY2P5dlaGZuL-Bmrj.jpg', 58);
INSERT INTO image VALUES(295, 'tai-nghe-bluetooth-tws-huawei-freebuds-3-den-3-org.jpg', 'aRQM-WUeqkshJgBVZDsQcM1D9Z4UMD8B.jpg', 58);
INSERT INTO image VALUES(296, 'tai-nghe-bluetooth-tws-huawei-freebuds-3-den-4-org.jpg', 'ew-1HWzyfNJEqC2Bmt07oC0TzKkF7JHI.jpg', 58);
INSERT INTO image VALUES(297, 'tai-nghe-chup-tai-bluetooth-sony-wh-xb700-1-3-org.jpg', 'belqp3UQdPg1B4CPkO6QkhOfZxf0nNW0.jpg', 59);
INSERT INTO image VALUES(298, 'tai-nghe-chup-tai-bluetooth-sony-wh-xb700-2-2-org.jpg', '9xGqYDC1-igEOCjzspizSZ3ROcyqzXzA.jpg', 59);
INSERT INTO image VALUES(299, 'tai-nghe-chup-tai-bluetooth-sony-wh-xb700-3-2-org.jpg', 'hwYmBrYgcjI08GJJbkiC0zXmqcgAxKmt.jpg', 59);
INSERT INTO image VALUES(300, 'the-nho-microsd-8gb-class-4-1-org-2.jpg', 'Zbb9-3JAcPPjbPgkHN0WyP9g7I5juQGh.jpg', 60);
INSERT INTO image VALUES(301, 'the-nho-microsd-8gb-class-4-1-org-3.jpg', '4keAuhlUfsmDS1Vw1ExP333G66Rf-XIg.jpg', 60);
INSERT INTO image VALUES(302, 'the-nho-microsd-8gb-class-4-1-org-4.jpg', 'N9iMUFLCwzvVWyoqe-aEU6i587JwCN-o.jpg', 60);
INSERT INTO image VALUES(303, 'the-nho-microsd-128gb-class-10-uhs1-moi-1-org.jpg', 'AARwQLZmUytVMNi2zLM8UiPzP2tjPFCS.jpg', 61);
INSERT INTO image VALUES(304, 'the-nho-microsd-128gb-class-10-uhs1-moi-2-org.jpg', 'yrmwncW681RkC9qsxfCRi1zArS6O0wBa.jpg', 61);
INSERT INTO image VALUES(305, 'the-nho-microsd-128gb-class-10-uhs1-moi-3-org.jpg', 'h2-2CS3Wc19hBvPPvCaGxqYS6x3EayD9.jpg', 61);
INSERT INTO image VALUES(306, 'o-cung-hdd-1tb-wd-my-passport-xanh-duong-6-org-1-org.jpg', '9RSizmN4F5AWKslL3aNao1hJe8RCDvCG.jpg', 62);
INSERT INTO image VALUES(307, 'o-cung-hdd-1tb-wd-my-passport-xanh-duong-7-org-1-org.jpg', 'rVgcxBkFyo71WuMFgLQ5OKEAXZlo5LeJ.jpg', 62);
INSERT INTO image VALUES(308, 'o-cung-hdd-1tb-wd-my-passport-xanh-duong-8-org-1-org.jpg', 'hGLMM5q4Ydfd9nqPgSaY5xHH7n-NL09e.jpg', 62);
INSERT INTO image VALUES(309, 'o-cung-hdd-1tb-seagate-backup-plus-slim-den-2-2-org.jpg', 'zS6fJyAoQAyf-HtJx0HFddgBd9XqU0f2.jpg', 63);
INSERT INTO image VALUES(310, 'o-cung-hdd-1tb-seagate-backup-plus-slim-den-3-2-org.jpg', 'elO-eXkwL3oZmOllkUHBHEyEarbriOBx.jpg', 63);
INSERT INTO image VALUES(311, 'o-cung-hdd-1tb-seagate-backup-plus-slim-den-4-2-org.jpg', '8proUdjpxyvXdhMxX6g6WPC4HfrU6mFy.jpg', 63);
INSERT INTO image VALUES(312, 'ipad-10-2-inch-wifi-128gb-2019-xam-1-org.jpg', 'eUccpQK5BfNosWR9Fs4PvW9wRth7uZIs.jpg', 64);
INSERT INTO image VALUES(313, 'ipad-10-2-inch-wifi-128gb-2019-xam-2-org.jpg', 'Quz-bIgYNHlh2493Q4xkYyXW1Z0YzaZC.jpg', 64);
INSERT INTO image VALUES(314, 'ipad-10-2-inch-wifi-128gb-2019-xam-3-org.jpg', '4nWCFLBlC8s49QN1t4mqqOBp1GfCCLMj.jpg', 64);
INSERT INTO image VALUES(315, 'ipad-10-2-inch-wifi-128gb-2019-xam-4-org.jpg', 'iw4md6qJk22vAML2acc9u9z4228mL0a5.jpg', 64);
INSERT INTO image VALUES(316, 'samsung-galaxy-tab-a8-t295-2019-den-1-org.jpg', 'iFLZXObEepHwL8kHaqKYuBbef2sz6WUy.jpg', 65);
INSERT INTO image VALUES(317, 'samsung-galaxy-tab-a8-t295-2019-den-10-org.jpg', 'AK13ggw-XZofnAdghjgUbr3aWQwmezok.jpg', 65);
INSERT INTO image VALUES(318, 'samsung-galaxy-tab-a8-t295-2019-den-2-org.jpg', '73zLDx3SW6STQDctCyYo20TDMsOJ2CVE.jpg', 65);
INSERT INTO image VALUES(319, 'samsung-galaxy-tab-a8-t295-2019-den-3-org.jpg', 'iYbxoiDqVagk1qYtSPJ8VWrt38HoTIsW.jpg', 65);
INSERT INTO image VALUES(320, 'samsung-galaxy-tab-a8-t295-2019-den-4-org.jpg', 'B69oMnyKHmOG7P9YDushy9mSgKZEEBVN.jpg', 65);
INSERT INTO image VALUES(321, 'samsung-galaxy-tab-a8-t295-2019-den-5-org.jpg', '19DlSor93w5Lg7bCCjCVUavvJo9NLreo.jpg', 65);
INSERT INTO image VALUES(322, 'samsung-galaxy-tab-a8-t295-2019-den-6-org.jpg', 'pSeXr6IYDxvfzr3EmiYDzUVaPV76Phbt.jpg', 65);
INSERT INTO image VALUES(323, 'samsung-galaxy-tab-a8-t295-2019-den-7-org.jpg', 'zTdSRYngDiwR0mw0VAtXrWcMWqDJTtfK.jpg', 65);
INSERT INTO image VALUES(324, 'samsung-galaxy-tab-a8-t295-2019-den-8-org.jpg', '1bVh6Wi6vEHULmvXkHtdXPSPU4eUXWc2.jpg', 65);
INSERT INTO image VALUES(325, 'samsung-galaxy-tab-a8-t295-2019-den-9-org.jpg', 'SJyiZNMN6qJSWqpfaUyxLoW3FBX9MJDc.jpg', 65);
INSERT INTO image VALUES(326, 'lenovo-tab-e10-tb-x104l-den-1-org.jpg', 'j147ARUezNqYVZTtZqjpmhjFqPzfVuAh.jpg', 66);
INSERT INTO image VALUES(327, 'lenovo-tab-e10-tb-x104l-den-10-org.jpg', 'FPDf-zgm4l7WYpHvkirg-MTkGrAwPhAx.jpg', 66);
INSERT INTO image VALUES(328, 'lenovo-tab-e10-tb-x104l-den-11-org.jpg', 'T5kXBmICZC77yPnm2XaPnSenaYYWIr-2.jpg', 66);
INSERT INTO image VALUES(329, 'lenovo-tab-e10-tb-x104l-den-12-org.jpg', 'Pq86mDscejlZd2CqSafbzJ6nZ7cpy2jE.jpg', 66);
INSERT INTO image VALUES(330, 'lenovo-tab-e10-tb-x104l-den-13-org.jpg', '7BJVKjwYWAnXN5XdvNDS8sh1djTSBhjN.jpg', 66);
INSERT INTO image VALUES(331, 'lenovo-tab-e10-tb-x104l-den-2-org.jpg', 'K3uwMo59uk2NGBViF3hgvKopgPPjDAbP.jpg', 66);
INSERT INTO image VALUES(332, 'lenovo-tab-e10-tb-x104l-den-3-org.jpg', 'qdAwa26jCd9LAe0d0cASNu2btzPensOl.jpg', 66);
INSERT INTO image VALUES(333, 'lenovo-tab-e10-tb-x104l-den-4-org.jpg', 'Q1vPRTRitD6wC7Yp9Qoxz2t2jrZpLDoB.jpg', 66);
INSERT INTO image VALUES(334, 'lenovo-tab-e10-tb-x104l-den-5-org.jpg', 'kxCMgkTyIZL2fitMmQOtyVk4at79yVhM.jpg', 66);
INSERT INTO image VALUES(335, 'lenovo-tab-e10-tb-x104l-den-6-org.jpg', 'sw170JwK5n049liCDQyRHdbP800fHxrr.jpg', 66);
INSERT INTO image VALUES(336, 'lenovo-tab-e10-tb-x104l-den-7-org.jpg', 'UmLKkNELnzq86A8Fea3XvOGa4-3nPDjV.jpg', 66);
INSERT INTO image VALUES(337, 'lenovo-tab-e10-tb-x104l-den-8-org.jpg', 'HFSnCQLOgUP2SwuzvneaYojkM6QSwp33.jpg', 66);
INSERT INTO image VALUES(338, 'lenovo-tab-e10-tb-x104l-den-9-org.jpg', 'aizCH3l35YbGnnXj1Btt2PXGgBCe1z4p.jpg', 66);
INSERT INTO image VALUES(339, 'mobell-tab-8-pro-vangdong1-1-org.jpg', 'R7-cyWE276alEu1aJzpus1O8GFPW5B2v.jpg', 67);
INSERT INTO image VALUES(340, 'mobell-tab-8-pro-vangdong1-2-org.jpg', 'xsf5OzYs3bywy2i0CNoy6iPxCFEBqwno.jpg', 67);
INSERT INTO image VALUES(341, 'mobell-tab-8-pro-vangdong1-3-org.jpg', '3Yo80pQPCOuVAdsYdXjL0qxSNpoDJ5Iu.jpg', 67);
INSERT INTO image VALUES(342, 'mobell-tab-8-pro-vangdong1-4-org.jpg', '3dEnhbjdXS4sN7aZpVkl4sJUdqtNsKzq.jpg', 67);
INSERT INTO image VALUES(343, 'mobell-tab-8-pro-vangdong1-5-org.jpg', 'HUVtr5-u4iWcIhDJtAhni4ILVoouDEDH.jpg', 67);
INSERT INTO image VALUES(344, 'mobell-tab-8-pro-vangdong1-6-org.jpg', 'sbl5VK7jYX9TlGsqpiQZGDs58wpdqs0Q.jpg', 67);
INSERT INTO image VALUES(345, 'mobell-tab-8-pro-vangdong1-7-org.jpg', 'Of7konA5eaDH7iYKHotetOYkGOR5MGqs.jpg', 67);
INSERT INTO image VALUES(346, 'lenovo-tab-e7-tb-7104i-den-1-org.jpg', 'OAUugIvqgQMgiIVS6Bq-klQTaofjaNqf.jpg', 68);
INSERT INTO image VALUES(347, 'lenovo-tab-e7-tb-7104i-den-10-org.jpg', 'MiFebazyVZGMBYWW8ka6TyYvdfxC-vcy.jpg', 68);
INSERT INTO image VALUES(348, 'lenovo-tab-e7-tb-7104i-den-11-org.jpg', 'fs59Us7qc9nhRMuorsjp6v3aYKnMWgh7.jpg', 68);
INSERT INTO image VALUES(349, 'lenovo-tab-e7-tb-7104i-den-2-org.jpg', 'EXzm6hEPXv4zRvJhlz4BaaguWpev2IBf.jpg', 68);
INSERT INTO image VALUES(350, 'lenovo-tab-e7-tb-7104i-den-3-org.jpg', 'NAN9XPSt9EWyN-5-kJMUIdDmDy0fBJd9.jpg', 68);
INSERT INTO image VALUES(351, 'lenovo-tab-e7-tb-7104i-den-4-org.jpg', 'BK95UdvEPHyj7rzGWIGcm192ezYEEC1-.jpg', 68);
INSERT INTO image VALUES(352, 'lenovo-tab-e7-tb-7104i-den-5-org.jpg', 'sLUysEfimdxy0r9OkJdK5X50OSI00U6e.jpg', 68);
INSERT INTO image VALUES(353, 'lenovo-tab-e7-tb-7104i-den-6-org.jpg', 'Ifld3brytheCMTQbm-Hw7Jduq-hDFp30.jpg', 68);
INSERT INTO image VALUES(354, 'lenovo-tab-e7-tb-7104i-den-7-org.jpg', '41tXRZA0nX0ilIYed7USnD4IfqKueR0L.jpg', 68);
INSERT INTO image VALUES(355, 'lenovo-tab-e7-tb-7104i-den-8-org.jpg', 'KNyRhtsPcCu3iEeRoViqowVxAkw3P70G.jpg', 68);
INSERT INTO image VALUES(356, 'lenovo-tab-e7-tb-7104i-den-9-org.jpg', 'xsvhXVLR2S7VwMUqtUk9EdP9WsbEDaW0.jpg', 68);
INSERT INTO image VALUES(357, 'ipad-mini-79-inch-wifi-2019-xam-1-org.jpg', 'wQA2ArUvEQwRXX-OLZnpJRy3EL4RKa2z.jpg', 69);
INSERT INTO image VALUES(358, 'ipad-mini-79-inch-wifi-2019-xam-2-org.jpg', 'ElIiypHGCXN4muW-ZZcp762gMiOf1Tjy.jpg', 69);
INSERT INTO image VALUES(359, 'ipad-mini-79-inch-wifi-2019-xam-3-org.jpg', 'gwMG-HDUZF4iClSZEf-6BThFx4r0Vtf-.jpg', 69);
INSERT INTO image VALUES(360, 'huawei-mediapad-t5-den-1-org.jpg', 'TA7T8Uz-aWC-GngKai0FwIiBHJHaqLLb.jpg', 70);
INSERT INTO image VALUES(361, 'huawei-mediapad-t5-den-10-org.jpg', '7lZ45pKD6-XcftI0lQXqhomjysUEuTUi.jpg', 70);
INSERT INTO image VALUES(362, 'huawei-mediapad-t5-den-11-org.jpg', 'enBw7Tgq0FDvcuTusOgAD3QR2YnZVGAy.jpg', 70);
INSERT INTO image VALUES(363, 'huawei-mediapad-t5-den-2-org.jpg', 'ZWq3txo8QVXugiC-x3JPHtGPa8TNd8Sh.jpg', 70);
INSERT INTO image VALUES(364, 'huawei-mediapad-t5-den-3-org.jpg', 'LITehwWsb4IWbxFOFSOIO95HT84UCogW.jpg', 70);
INSERT INTO image VALUES(365, 'huawei-mediapad-t5-den-4-org.jpg', 'hwuEH-8IhvmynJWDahfKTEUxVe-8kKRb.jpg', 70);
INSERT INTO image VALUES(366, 'huawei-mediapad-t5-den-5-org.jpg', 'XE0UfvWgGWxWOiv0IHjZvOPcRSZDrhUr.jpg', 70);
INSERT INTO image VALUES(367, 'huawei-mediapad-t5-den-6-org.jpg', 'Ak3BqtKPcesAoMFE-m5DnEMc6KW3dJF-.jpg', 70);
INSERT INTO image VALUES(368, 'huawei-mediapad-t5-den-7-org.jpg', 'TosnskBqPCtftF-SZKGBRafyHehmQEeq.jpg', 70);
INSERT INTO image VALUES(369, 'huawei-mediapad-t5-den-8-org.jpg', 'JSryE3msDiGTcvWriWbR8S1pEZ4MHK3c.jpg', 70);
INSERT INTO image VALUES(370, 'huawei-mediapad-t5-den-9-org.jpg', 'Mrgg8XrbI6DHnOZt1SUZKiuwJnJ-LCJX.jpg', 70);
INSERT INTO image VALUES(371, 'samsung-galaxy-tab-a8-plus-p205-den-1-org.jpg', '76bAnnj8Yy6JrGY2DxNLp6cA-BzPMGDc.jpg', 71);
INSERT INTO image VALUES(372, 'samsung-galaxy-tab-a8-plus-p205-den-10-org.jpg', 'g8gwYAeyUkUOm-QlL1Qf2v-FKsV5avep.jpg', 71);
INSERT INTO image VALUES(373, 'samsung-galaxy-tab-a8-plus-p205-den-11-org.jpg', '6aYMMaEqOf2qwuYXosfClZtXNpjM4H6D.jpg', 71);
INSERT INTO image VALUES(374, 'samsung-galaxy-tab-a8-plus-p205-den-12-org.jpg', 'oqkeol9rTTa2fb6a0x-BntMQgvG2yVJZ.jpg', 71);
INSERT INTO image VALUES(375, 'samsung-galaxy-tab-a8-plus-p205-den-13-org.jpg', 'm8Cm7XbdYoRu69E0zFV61OqSfYjyYy96.jpg', 71);
INSERT INTO image VALUES(376, 'samsung-galaxy-tab-a8-plus-p205-den-14-org.jpg', 'kzpjyx8sXL4dK0C24Zu9HGzSNZ6n4ye1.jpg', 71);
INSERT INTO image VALUES(377, 'samsung-galaxy-tab-a8-plus-p205-den-2-org.jpg', 'Tz--wpYAfZot6yB30Q2TBfxUyMfYF-hP.jpg', 71);
INSERT INTO image VALUES(378, 'samsung-galaxy-tab-a8-plus-p205-den-3-org.jpg', 'bikeIZ8dL-Y9I9v0UWG3Cf4qGdyx3vdR.jpg', 71);
INSERT INTO image VALUES(379, 'samsung-galaxy-tab-a8-plus-p205-den-4-org.jpg', 'KFDFyFmUOxdTk37aTuYAJ0sex4221XIf.jpg', 71);
INSERT INTO image VALUES(380, 'samsung-galaxy-tab-a8-plus-p205-den-5-org.jpg', 'Niqwf4X0uVhdzl-eWmnLZ-DgnqWmrqUu.jpg', 71);
INSERT INTO image VALUES(381, 'samsung-galaxy-tab-a8-plus-p205-den-6-org.jpg', '1znCzyS67okt62jQziXUJANIcLPbqT76.jpg', 71);
INSERT INTO image VALUES(382, 'samsung-galaxy-tab-a8-plus-p205-den-7-org.jpg', 'Cu8JT71dixmCeHc3OXudkmfCpK4uBRXo.jpg', 71);
INSERT INTO image VALUES(383, 'samsung-galaxy-tab-a8-plus-p205-den-8-org.jpg', 'mLoB7jS5Jr6OyFv4ayAiVlsttJhwqu4N.jpg', 71);
INSERT INTO image VALUES(384, 'samsung-galaxy-tab-a8-plus-p205-den-9-org.jpg', 'Tn3krpZ1xIrYsVvc81Wv6vtjYPBwa982.jpg', 71);
INSERT INTO image VALUES(385, 'huawei-mediapad-m5-lite-xam-1-org.jpg', 'mEW4fVhqs-Qa3aYRaUw9ZzXh85Nb1fOA.jpg', 72);
INSERT INTO image VALUES(386, 'huawei-mediapad-m5-lite-xam-10-org.jpg', 'WokUP0qPKP82yYiWz169YJ7kT9dciuvD.jpg', 72);
INSERT INTO image VALUES(387, 'huawei-mediapad-m5-lite-xam-11-org.jpg', 'iU7R0zLXGZ55ITFsFlFf3JracdLm8Fxr.jpg', 72);
INSERT INTO image VALUES(388, 'huawei-mediapad-m5-lite-xam-12-org.jpg', 'FVuPRjpURrLaeBTwNeJX6tqdjjOQfvaD.jpg', 72);
INSERT INTO image VALUES(389, 'huawei-mediapad-m5-lite-xam-2-org.jpg', 'gcWFzAyEB7gBH6qKJm3i-JhpUEGrf94u.jpg', 72);
INSERT INTO image VALUES(390, 'huawei-mediapad-m5-lite-xam-3-org.jpg', 'Q1DlZCDkG53elIgnQknmd-OXlQxLOItU.jpg', 72);
INSERT INTO image VALUES(391, 'huawei-mediapad-m5-lite-xam-4-org.jpg', '0nVzdu5VTN4iRevggvYQN8grYELfHz4n.jpg', 72);
INSERT INTO image VALUES(392, 'huawei-mediapad-m5-lite-xam-5-org.jpg', 'Iq9Z3HOJZukBM1qNvwDmOEQy4Hcp6by5.jpg', 72);
INSERT INTO image VALUES(393, 'huawei-mediapad-m5-lite-xam-6-org.jpg', 'VI-kabFrbQmQTYsrKxEO72qD9y4vNNZ9.jpg', 72);
INSERT INTO image VALUES(394, 'huawei-mediapad-m5-lite-xam-7-org.jpg', 'GqBUWnQPsgXYBVSWkYe1je0YttbHkrdV.jpg', 72);
INSERT INTO image VALUES(395, 'huawei-mediapad-m5-lite-xam-8-org.jpg', '4c6VoP6aBaWRt3aqkRi9xdD97EVa3avh.jpg', 72);
INSERT INTO image VALUES(396, 'huawei-mediapad-m5-lite-xam-9-org.jpg', 'ys4cc6talLjS65PxmzENqQahHg0ZSMLM.jpg', 72);
INSERT INTO image VALUES(397, 'ipad-air-105-inch-wifi-2019-xam-1-1-org.jpg', 'V20kWJvHqCSjcS5VURtxjf-yEkFSFcd6.jpg', 73);
INSERT INTO image VALUES(398, 'ipad-air-105-inch-wifi-2019-xam-1-org.jpg', '1Xi2lUm9imbzGMExULDBDCTN8CQZ6Rlv.jpg', 73);
INSERT INTO image VALUES(399, 'ipad-air-105-inch-wifi-2019-xam-10-org.jpg', 'NaIrPUPp8S8wtLUUBq4xTSWdcI6Lr2hW.jpg', 73);
INSERT INTO image VALUES(400, 'ipad-air-105-inch-wifi-2019-xam-11-org.jpg', 'fOVZTVT3OuzXFR2JsXOhMLfOjzLVVQi4.jpg', 73);
INSERT INTO image VALUES(401, 'ipad-air-105-inch-wifi-2019-xam-12-org.jpg', 'FG9R30WwZjp4-JCMa4uxmdNQdtnX0CPH.jpg', 73);
INSERT INTO image VALUES(402, 'ipad-air-105-inch-wifi-2019-xam-2-org.jpg', 'GkdiGfYn2VteaKdsJu0bBF1FDoPYXP-y.jpg', 73);
INSERT INTO image VALUES(403, 'ipad-air-105-inch-wifi-2019-xam-3-org.jpg', 'XVBhrZ-ATrvErjyb7sw7ucs5WfUTsrRY.jpg', 73);
INSERT INTO image VALUES(404, 'ipad-air-105-inch-wifi-2019-xam-4-org.jpg', 'mF77xfRIIhwUR7Om4b4fMSzITtzY9MPO.jpg', 73);
INSERT INTO image VALUES(405, 'ipad-air-105-inch-wifi-2019-xam-5-org.jpg', 'yVJoJdVrYtQ7bgErpOk3WxO5U78gtqxQ.jpg', 73);
INSERT INTO image VALUES(406, 'ipad-air-105-inch-wifi-2019-xam-6-org.jpg', 'U5z5O7KL3eI6H4hrTvc2GWjRiwrvTLbc.jpg', 73);
INSERT INTO image VALUES(407, 'ipad-air-105-inch-wifi-2019-xam-7-org.jpg', '2BLpQ6pJwYZcBWdjDUSZUVo6nUpBRorz.jpg', 73);
INSERT INTO image VALUES(408, 'ipad-air-105-inch-wifi-2019-xam-8-org.jpg', '7rT1d3F0zAqLaMIWJdHsGD64p4exo6wN.jpg', 73);
INSERT INTO image VALUES(409, 'ipad-air-105-inch-wifi-2019-xam-9-org.jpg', 'i2FMJ7gUCvKqAxFuFutED1kXi5hfZI0t.jpg', 73);
INSERT INTO image VALUES(410, 'masstel-tab10-pro-bac-1-org.jpg', '3AVzG8H32axUlnhUGgNei294bqK2lLTg.jpg', 74);
INSERT INTO image VALUES(411, 'masstel-tab10-pro-bac-10-org.jpg', 'a4JiGfFOm6ImXZ1iognRxzLaMNMWcFP1.jpg', 74);
INSERT INTO image VALUES(412, 'masstel-tab10-pro-bac-11-org.jpg', 'xlQ2dMinWi67TsCddIHcCFsP6mkDcL9C.jpg', 74);
INSERT INTO image VALUES(413, 'masstel-tab10-pro-bac-2-org.jpg', 'tbTwrufRH4BSxCBN9c1fpe1ggUZAqA14.jpg', 74);
INSERT INTO image VALUES(414, 'masstel-tab10-pro-bac-3-org.jpg', 'mroVf91h99d0XFzbDpIKsTlXm2JrZM8F.jpg', 74);
INSERT INTO image VALUES(415, 'masstel-tab10-pro-bac-4-org.jpg', '4OSoqGwBNGWSwwJac7-0r0E7gfTZNR2Y.jpg', 74);
INSERT INTO image VALUES(416, 'masstel-tab10-pro-bac-5-org.jpg', 'QNqCMjzohB0ZQPDmZndP3XS3qTvqgTeP.jpg', 74);
INSERT INTO image VALUES(417, 'masstel-tab10-pro-bac-6-org.jpg', '77upOOGUSrLvRT5f-zJGdss3txO7Wbpu.jpg', 74);
INSERT INTO image VALUES(418, 'masstel-tab10-pro-bac-7-org.jpg', 'Sgfw67PBUdQ3UoDJGeOur2Cezqbd34Py.jpg', 74);
INSERT INTO image VALUES(419, 'masstel-tab10-pro-bac-8-org.jpg', 'neBOM86G5yQJ9epo7W0gYW5vjj0V1dz5.jpg', 74);
INSERT INTO image VALUES(420, 'masstel-tab10-pro-bac-9-org.jpg', 'J6IZY9IypyQEsw7uiozovGlcogzNSTZe.jpg', 74);
INSERT INTO image VALUES(421, 'samsung-galaxy-tab-s6-xanh-duong-1-org.jpg', 'yvL6ZwXHPRtSA42-QmGDOO67akAJ6N6E.jpg', 75);
INSERT INTO image VALUES(422, 'samsung-galaxy-tab-s6-xanh-duong-10-org.jpg', 'bp4rXiyB6fLyQx8ZgxGUEABzkk3aBg8A.jpg', 75);
INSERT INTO image VALUES(423, 'samsung-galaxy-tab-s6-xanh-duong-11-org.jpg', '5NlMclUHZ8yQUZR9Tkn7eO71EUvmDMfM.jpg', 75);
INSERT INTO image VALUES(424, 'samsung-galaxy-tab-s6-xanh-duong-12-org.jpg', 'M1U4-282f7BHbYRqCogwT8PomkjNr8c9.jpg', 75);
INSERT INTO image VALUES(425, 'samsung-galaxy-tab-s6-xanh-duong-13-org.jpg', '2g1eSolPDBe0o2YjJCsxMVTLx6AzysD5.jpg', 75);
INSERT INTO image VALUES(426, 'samsung-galaxy-tab-s6-xanh-duong-14-org.jpg', 'kAprAiaGRyo53IImGcCRJY4gekravQG6.jpg', 75);
INSERT INTO image VALUES(427, 'samsung-galaxy-tab-s6-xanh-duong-15-org.jpg', 'AASzv3WraW2sIjGZhtOORoS-JdUs3MPv.jpg', 75);
INSERT INTO image VALUES(428, 'samsung-galaxy-tab-s6-xanh-duong-2-org.jpg', 'mPol5AG-QPYgtYuFnnJSlYODl6ORyeib.jpg', 75);
INSERT INTO image VALUES(429, 'samsung-galaxy-tab-s6-xanh-duong-3-org.jpg', 'yGq4A3gzEEADkHMMRmWuqteKDoUJ5XpB.jpg', 75);
INSERT INTO image VALUES(430, 'samsung-galaxy-tab-s6-xanh-duong-4-org.jpg', 'ZDW3ow8uZOb7UyNvUoyLPIyUlS93RJ9g.jpg', 75);
INSERT INTO image VALUES(431, 'samsung-galaxy-tab-s6-xanh-duong-5-org.jpg', 'iCGFEet8PBg9orwxBJDPTN827i2Au6iM.jpg', 75);
INSERT INTO image VALUES(432, 'samsung-galaxy-tab-s6-xanh-duong-6-org.jpg', 'NyCg9WRmeztaMyPHs1HheHlzipsi340a.jpg', 75);
INSERT INTO image VALUES(433, 'samsung-galaxy-tab-s6-xanh-duong-7-org.jpg', 'vG5-Por9l0Bk3mg3C5Fh-23j0wZevBst.jpg', 75);
INSERT INTO image VALUES(434, 'samsung-galaxy-tab-s6-xanh-duong-8-org.jpg', 'll8-9uFlqLqEjLWWmMBmyx1kc-DB7h01.jpg', 75);
INSERT INTO image VALUES(435, 'samsung-galaxy-tab-s6-xanh-duong-9-org.jpg', 'qppaIzjgBbUI2WrAkAc5m2X77oHKofYP.jpg', 75);
INSERT INTO image VALUES(436, 'watch-gt2-46mm-day-sillicone-den-1-org.jpg', 'VUPKlssWMKQuslX2B49E7C7FA8hpc3Ae.jpg', 76);
INSERT INTO image VALUES(437, 'watch-gt2-46mm-day-sillicone-den-10-org.jpg', 'QIsRuIJNI1iBdW4u265QjzyEadUYpOLs.jpg', 76);
INSERT INTO image VALUES(438, 'watch-gt2-46mm-day-sillicone-den-11-org.jpg', 'Sixfru9JkbX2OelZht37P1B6NjcHY8Ok.jpg', 76);
INSERT INTO image VALUES(439, 'watch-gt2-46mm-day-sillicone-den-2-org.jpg', 'oe22R5wulsQkLm67eW8dj56AUJH-V8Av.jpg', 76);
INSERT INTO image VALUES(440, 'watch-gt2-46mm-day-sillicone-den-3-org.jpg', '2DMdXlRQVGnpaEHdIG34t3pOEGA4TnxH.jpg', 76);
INSERT INTO image VALUES(441, 'watch-gt2-46mm-day-sillicone-den-4-org.jpg', 'X0HOdFGSQy-kAnIErRaPHwS89MCYR3zy.jpg', 76);
INSERT INTO image VALUES(442, 'watch-gt2-46mm-day-sillicone-den-5-org.jpg', 'x36gbSaFb0I8sF9E91nCAaIYsDoZmrPz.jpg', 76);
INSERT INTO image VALUES(443, 'watch-gt2-46mm-day-sillicone-den-6-org.jpg', 'L5Hcx87TiaQALLi9Ea4XsLmuBzQzI1mA.jpg', 76);
INSERT INTO image VALUES(444, 'watch-gt2-46mm-day-sillicone-den-7-org.jpg', 'RaYuVFRbh5EiFp9sVKIYWeJYXglY81KA.jpg', 76);
INSERT INTO image VALUES(445, 'watch-gt2-46mm-day-sillicone-den-8-org.jpg', 'OYEPHl3oXMlXC1XRoekyz2gnEnuvyUYH.jpg', 76);
INSERT INTO image VALUES(446, 'watch-gt2-46mm-day-sillicone-den-9-org.jpg', 'f-kaEtxiwUBFV-v0AABFC520ShEusQJx.jpg', 76);
INSERT INTO image VALUES(447, 'xiaomi-amazfit-bip-den-1-1-org.jpg', 'X1DQLmPAE5oWbBts78E8LhCWy5eoMnhK.jpg', 77);
INSERT INTO image VALUES(448, 'xiaomi-amazfit-bip-den-2-1-org.jpg', 'oIsxNcfXirKxKCdMG6yy4bd45UMyinZg.jpg', 77);
INSERT INTO image VALUES(449, 'xiaomi-amazfit-bip-den-3-1-org.jpg', 'dAlUhW5rvNpyPRGKhCtoZYTK9s8-is6e.jpg', 77);
INSERT INTO image VALUES(450, 'xiaomi-amazfit-bip-den-4-1-org.jpg', '0qSjJHhdCca1BSIw7WXkTXjKeL2q4I4f.jpg', 77);
INSERT INTO image VALUES(451, 'xiaomi-amazfit-bip-den-5-1-org.jpg', 'VrG0QAIz6Sh9fn-8WZ0ePGLl7BYy4Sip.jpg', 77);
INSERT INTO image VALUES(452, 'xiaomi-amazfit-bip-den-6-1-org.jpg', 'mLh4U3vgPhwL8M8ZWf40mVt9W5IbEoXW.jpg', 77);
INSERT INTO image VALUES(453, 'xiaomi-amazfit-bip-den-7-1-org.jpg', 'YA7J45QIUFbPinGeLF0xTFTFSeosSKI7.jpg', 77);
INSERT INTO image VALUES(454, 'xiaomi-amazfit-bip-den-8-1-org.jpg', 'zaU0pV9FIrpEYeHhm8DAWLDYTcT8xnG8.jpg', 77);
INSERT INTO image VALUES(455, 'xiaomi-amazfit-bip-den-9-1-org.jpg', 'A-MumNf7c09GHQr0YMIndep4aCBVK91O.jpg', 77);
INSERT INTO image VALUES(456, 'samsung-galaxy-watch-active-r500-bac-1-org.jpg', 'bqhLM5xRilqn0EXouEr4-ToAuLgbQuUd.jpg', 78);
INSERT INTO image VALUES(457, 'samsung-galaxy-watch-active-r500-bac-2-org.jpg', 'IFrOVYcnManmUdgFLdyz7vvOpvldsHf3.jpg', 78);
INSERT INTO image VALUES(458, 'samsung-galaxy-watch-active-r500-bac-3-org.jpg', 'RUQ5sRkhT2LJDc2HsOe4jzPEDHBZnPZq.jpg', 78);
INSERT INTO image VALUES(459, 'samsung-galaxy-watch-active-r500-bac-4-org.jpg', 'aQoBaH8IG7V2Tfkmh-okK4mJKHCXFe2Z.jpg', 78);
INSERT INTO image VALUES(460, 'samsung-galaxy-watch-active-r500-bac-5-org.jpg', 'C7UgUR1bnsFwHLW4sTgfnp40zlMyMzys.jpg', 78);
INSERT INTO image VALUES(461, 'samsung-galaxy-watch-active-r500-bac-6-org.jpg', 'ESA1fKcuGkDeOJmMAMjjuSQpLMzTSqfl.jpg', 78);
INSERT INTO image VALUES(462, 'samsung-galaxy-watch-active-r500-bac-7-org.jpg', 'qxH1HRCGNLOdlt4rhfIEQn455NrHmmOa.jpg', 78);
INSERT INTO image VALUES(463, 'samsung-galaxy-watch-active-r500-bac-8-org.jpg', 'ieGZQAVzBO9KMvRnUGp-pLcHJo86I9ce.jpg', 78);
INSERT INTO image VALUES(464, 'samsung-galaxy-watch-active-r500-bac-9-org.jpg', 'HPJzczYU9oklX8zMZsrnT2hmmPDk3Qo6.jpg', 78);
INSERT INTO image VALUES(465, 'samsung-galaxy-watch-active-r500-bac-org.jpg', 'GO9G0ZGTR0iLOjRVFGO3k-cUg73HnJpK.jpg', 78);
INSERT INTO image VALUES(466, 'samsung-galaxy-watch-active-r500-den-1-org.jpg', 'PkgmZWNxEKiSuBBEMoglGd-KLXrFqnei.jpg', 78);
INSERT INTO image VALUES(467, 'samsung-galaxy-watch-active-r500-den-2-org.jpg', 'egLjFnmKetRcbYC1mjlN3Q7cqmbzZ7Gq.jpg', 78);
INSERT INTO image VALUES(468, 'samsung-galaxy-watch-active-r500-den-3-org.jpg', 'XeJSSLnFf2B7ZDRCXxKIy6TbpxPs3UJo.jpg', 78);
INSERT INTO image VALUES(469, 'samsung-galaxy-watch-active-r500-den-4-org.jpg', 'gan1H5yPqquVKy16kryTVt92dRZvM4G0.jpg', 78);
INSERT INTO image VALUES(470, 'samsung-galaxy-watch-active-r500-den-5-org.jpg', 've0wPWZx3o11daOIzWUxgsrw4WkpKybz.jpg', 78);
INSERT INTO image VALUES(471, 'samsung-galaxy-watch-active-r500-den-6-org.jpg', 'rM39jZkO4u8VQHFVl9i5R7GWgVWXUWxv.jpg', 78);
INSERT INTO image VALUES(472, 'samsung-galaxy-watch-active-r500-den-7-org.jpg', 'HdZS6rmJHeBV9gAb1Jnby4anwCX973im.jpg', 78);
INSERT INTO image VALUES(473, 'samsung-galaxy-watch-active-r500-den-8-org.jpg', 'g4HlNJLK5qFmldEpdUQQEddZnwluTEfR.jpg', 78);
INSERT INTO image VALUES(474, 'samsung-galaxy-watch-active-r500-den-9-org.jpg', 'p616oMhrIBFb5284laieLNywEBb8cpXd.jpg', 78);
INSERT INTO image VALUES(475, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-1-org.jpg', 'fsI2lC6lrK5UMxEu29HjQvYRCZy0RZ2x.jpg', 79);
INSERT INTO image VALUES(476, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-2-org.jpg', 'asSomk-ROc50RgtrDU2spy6fydDZK-2T.jpg', 79);
INSERT INTO image VALUES(477, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-3-org.jpg', '6TosIyTb6EbBKE5Z2xMpBQ41LWPbrNI3.jpg', 79);
INSERT INTO image VALUES(478, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-4-org.jpg', 'WxmBTVgRWGtgUDC5NBafjaSNpkYywZeX.jpg', 79);
INSERT INTO image VALUES(479, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-5-org.jpg', 'EjW42wYWCwPZmtNJgRynYldBXclqhm4L.jpg', 79);
INSERT INTO image VALUES(480, 'apple-watch-s5-44mm-vien-nhom-day-cao-su-org.jpg', 'is3mKuCncYh9UNcERUpTyZR6CFosm6Hn.jpg', 79);
INSERT INTO image VALUES(481, 'zeblaze-plug-c-den-1-1-org.jpg', 'g9JP-6WlwA-Mu7tUkCb5uOb-evjMLe26.jpg', 80);
INSERT INTO image VALUES(482, 'zeblaze-plug-c-den-1-org.jpg', 'xVEeHGDz88tj1MBRhcfAhaAD3-56pA2K.jpg', 80);
INSERT INTO image VALUES(483, 'zeblaze-plug-c-den-10-org.jpg', '2SgLFUBVV0Xy-YfI9uDMYUlTXC5s8MKG.jpg', 80);
INSERT INTO image VALUES(484, 'zeblaze-plug-c-den-11-org.jpg', 'klSXet3wtnNLSh8afSSrnssI2xgu13Wf.jpg', 80);
INSERT INTO image VALUES(485, 'zeblaze-plug-c-den-12-org.jpg', 'lApJZ9weOoeolejBhtZIe0uleaSHuI0q.jpg', 80);
INSERT INTO image VALUES(486, 'zeblaze-plug-c-den-13-org.jpg', 'U-mJj8soeJeOXy7P-MzXEf1s5ogJogw1.jpg', 80);
INSERT INTO image VALUES(487, 'zeblaze-plug-c-den-2-3-org.jpg', 'KmcTC5VmbKaJhcCX4VJDr39Z3Aj-8hPQ.jpg', 80);
INSERT INTO image VALUES(488, 'zeblaze-plug-c-den-2-org.jpg', 'LQ8E8IitJw91xJJSEyQvEqoa3Qj8FrZf.jpg', 80);
INSERT INTO image VALUES(489, 'zeblaze-plug-c-den-3-3-org.jpg', 'm8DJRE1MPBC2hLnFgHFCJwOJ7RyoohGe.jpg', 80);
INSERT INTO image VALUES(490, 'zeblaze-plug-c-den-3-org.jpg', 'lm1gvsqP38iq0gbTimCgNAqP0dXVhgT-.jpg', 80);
INSERT INTO image VALUES(491, 'zeblaze-plug-c-den-4-1-org.jpg', '5tzL5q7NfZe3gd8k4RClDRfHD83jPkC5.jpg', 80);
INSERT INTO image VALUES(492, 'zeblaze-plug-c-den-4-org.jpg', 'KgdeNkXLsKKdhGZpKVAH7TOfGnfnZeI6.jpg', 80);
INSERT INTO image VALUES(493, 'zeblaze-plug-c-den-5-1-org.jpg', 'eSAQm43MUhKqgHxp5leETgKfLVCqD7v5.jpg', 80);
INSERT INTO image VALUES(494, 'zeblaze-plug-c-den-5-org.jpg', '57va7M7pqHFjll57fx1OEjNzDjtDGWeA.jpg', 80);
INSERT INTO image VALUES(495, 'zeblaze-plug-c-den-6-2-org.jpg', 'FuuW3AxYbLVzuTMTydxtGgojIOw4I12Q.jpg', 80);
INSERT INTO image VALUES(496, 'zeblaze-plug-c-den-6-org.jpg', '1bNwuYws5A5tGmxQoRY3Y4vXAwE2PASR.jpg', 80);
INSERT INTO image VALUES(497, 'zeblaze-plug-c-den-7-org.jpg', 'tZI9-yku9YyjYOBoI4ov2Vdr9Mkl1PF-.jpg', 80);
INSERT INTO image VALUES(498, 'zeblaze-plug-c-den-8-org.jpg', '3wqtQcwNP0yNlq8uEZBMUSJUmaVHTQ3z.jpg', 80);
INSERT INTO image VALUES(499, 'zeblaze-plug-c-den-9-org.jpg', 'HKCbE-22E21aqL2g-981sOhR3EPZ2DGn.jpg', 80);



COMMIT;


UPDATE product SET MAIN_IMAGE=46 WHERE ID=16;
UPDATE product SET MAIN_IMAGE=52 WHERE ID=17;
UPDATE product SET MAIN_IMAGE=56 WHERE ID=18;
UPDATE product SET MAIN_IMAGE=60 WHERE ID=19;
UPDATE product SET MAIN_IMAGE=64 WHERE ID=20;
UPDATE product SET MAIN_IMAGE=67 WHERE ID=21;
UPDATE product SET MAIN_IMAGE=70 WHERE ID=22;
UPDATE product SET MAIN_IMAGE=73 WHERE ID=24;
UPDATE product SET MAIN_IMAGE=86 WHERE ID=25;
UPDATE product SET MAIN_IMAGE=103 WHERE ID=26;
UPDATE product SET MAIN_IMAGE=118 WHERE ID=27;
UPDATE product SET MAIN_IMAGE=134 WHERE ID=28;
UPDATE product SET MAIN_IMAGE=148 WHERE ID=29;
UPDATE product SET MAIN_IMAGE=151 WHERE ID=30;
UPDATE product SET MAIN_IMAGE=154 WHERE ID=31;
UPDATE product SET MAIN_IMAGE=157 WHERE ID=32;
UPDATE product SET MAIN_IMAGE=160 WHERE ID=33;
UPDATE product SET MAIN_IMAGE=163 WHERE ID=34;
UPDATE product SET MAIN_IMAGE=166 WHERE ID=36;
UPDATE product SET MAIN_IMAGE=169 WHERE ID=37;
UPDATE product SET MAIN_IMAGE=172 WHERE ID=38;
UPDATE product SET MAIN_IMAGE=175 WHERE ID=40;
UPDATE product SET MAIN_IMAGE=182 WHERE ID=41;
UPDATE product SET MAIN_IMAGE=206 WHERE ID=42;
UPDATE product SET MAIN_IMAGE=218 WHERE ID=43;
UPDATE product SET MAIN_IMAGE=229 WHERE ID=44;
UPDATE product SET MAIN_IMAGE=253 WHERE ID=45;
UPDATE product SET MAIN_IMAGE=256 WHERE ID=46;
UPDATE product SET MAIN_IMAGE=259 WHERE ID=47;
UPDATE product SET MAIN_IMAGE=262 WHERE ID=48;
UPDATE product SET MAIN_IMAGE=265 WHERE ID=49;
UPDATE product SET MAIN_IMAGE=268 WHERE ID=50;
UPDATE product SET MAIN_IMAGE=271 WHERE ID=51;
UPDATE product SET MAIN_IMAGE=274 WHERE ID=52;
UPDATE product SET MAIN_IMAGE=277 WHERE ID=53;
UPDATE product SET MAIN_IMAGE=280 WHERE ID=54;
UPDATE product SET MAIN_IMAGE=283 WHERE ID=55;
UPDATE product SET MAIN_IMAGE=286 WHERE ID=56;
UPDATE product SET MAIN_IMAGE=290 WHERE ID=57;
UPDATE product SET MAIN_IMAGE=293 WHERE ID=58;
UPDATE product SET MAIN_IMAGE=297 WHERE ID=59;
UPDATE product SET MAIN_IMAGE=300 WHERE ID=60;
UPDATE product SET MAIN_IMAGE=303 WHERE ID=61;
UPDATE product SET MAIN_IMAGE=306 WHERE ID=62;
UPDATE product SET MAIN_IMAGE=309 WHERE ID=63;
UPDATE product SET MAIN_IMAGE=312 WHERE ID=64;
UPDATE product SET MAIN_IMAGE=316 WHERE ID=65;
UPDATE product SET MAIN_IMAGE=326 WHERE ID=66;
UPDATE product SET MAIN_IMAGE=339 WHERE ID=67;
UPDATE product SET MAIN_IMAGE=346 WHERE ID=68;
UPDATE product SET MAIN_IMAGE=357 WHERE ID=69;
UPDATE product SET MAIN_IMAGE=360 WHERE ID=70;
UPDATE product SET MAIN_IMAGE=371 WHERE ID=71;
UPDATE product SET MAIN_IMAGE=385 WHERE ID=72;
UPDATE product SET MAIN_IMAGE=397 WHERE ID=73;
UPDATE product SET MAIN_IMAGE=410 WHERE ID=74;
UPDATE product SET MAIN_IMAGE=421 WHERE ID=75;
UPDATE product SET MAIN_IMAGE=436 WHERE ID=76;
UPDATE product SET MAIN_IMAGE=447 WHERE ID=77;
UPDATE product SET MAIN_IMAGE=456 WHERE ID=78;
UPDATE product SET MAIN_IMAGE=475 WHERE ID=79;
UPDATE product SET MAIN_IMAGE=481 WHERE ID=80;

COMMIT;