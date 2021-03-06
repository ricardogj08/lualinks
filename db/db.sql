/**
 * https://drive.google.com/file/d/16GmO5sR8LslQifrDpxRBfPA1-NVbitbN/view?usp=sharing
 */

CREATE DATABASE IF NOT EXISTS lualinks
  CHARACTER SET = 'utf8mb4'
  COLLATE = 'utf8mb4_spanish_ci';

USE lualinks;

CREATE TABLE IF NOT EXISTS role (
  id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(8) NOT NULL,
  description VARCHAR(16) NOT NULL,
  CONSTRAINT role_id_pk PRIMARY KEY (id),
  CONSTRAINT role_name_uk UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS user (
  id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(64) NOT NULL,
  role_id TINYINT UNSIGNED NOT NULL,
  password VARCHAR(256) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT NOW(),
  updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  CONSTRAINT user_id_pk PRIMARY KEY (id),
  CONSTRAINT user_role_id_fk FOREIGN KEY (role_id) REFERENCES role (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT user_username_uk UNIQUE (username)
);

CREATE TABLE IF NOT EXISTS bookmark (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id MEDIUMINT UNSIGNED NOT NULL,
  url VARCHAR(2048) NOT NULL,
  archive VARCHAR(2048) NULL,
  title VARCHAR(512) NOT NULL,
  description VARCHAR(1024) NULL,
  created_at DATETIME NOT NULL DEFAULT NOW(),
  updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  CONSTRAINT bookmark_id_pk PRIMARY KEY (id),
  CONSTRAINT bookmark_user_id_fk FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT bookmark_user_id_url_uk UNIQUE (url, user_id)
);

CREATE TABLE IF NOT EXISTS tag (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(64) NOT NULL,
  user_id MEDIUMINT UNSIGNED NOT NULL,
  CONSTRAINT tag_id_pk PRIMARY KEY (id),
  CONSTRAINT tag_user_id_fk FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT tag_name_user_id_uk UNIQUE (name, user_id)
);

CREATE TABLE IF NOT EXISTS bookmark_tag (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  bookmark_id BIGINT UNSIGNED NOT NULL,
  tag_id BIGINT UNSIGNED NOT NULL,
  CONSTRAINT bookmark_tag_id_pk PRIMARY KEY (id),
  CONSTRAINT bookmark_tag_bookmark_id_fk FOREIGN KEY (bookmark_id) REFERENCES bookmark (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT bookmark_tag_tag_id_fk FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT bookmark_tag_bookmark_id_tag_id_uk UNIQUE (bookmark_id, tag_id)
);

INSERT IGNORE INTO role VALUES (1, 'admin', 'Administrator'), (2, 'user', 'User');
INSERT IGNORE INTO user (id, username, role_id, password) VALUES (1, 'admin', 1, '$2a$12$BjJg4m/OA898WDkPJ1oL1./arBs0rs8oKQArOw8y1SmIeI40d2WKa');
