-- MySQL Script generated by MySQL Workbench
-- Wed Jun 11 17:36:29 2025
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DROP VIEW IF EXISTS madangdb.emp_list;
-- -----------------------------------------------------
-- Schema pjtdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pjtdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pjtdb` DEFAULT CHARACTER SET utf8 ;
USE `pjtdb` ;

-- -----------------------------------------------------
-- Table `pjtdb`.`Students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`Students` (
  `student_id` INT NOT NULL,
  `department` VARCHAR(45) NULL,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `phone` VARCHAR(45) NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`order_statuses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`order_statuses` (
  `status_code` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`status_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`GroupOrders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`GroupOrders` (
  `order_id` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `deadline` DATETIME NULL,
  `status_code` VARCHAR(45) NULL,
  `vendor` VARCHAR(45) NULL,
  `order_statuses_status_code` VARCHAR(20) NOT NULL,
  `Students_organizer_id` INT NOT NULL,
  `create_at` DATETIME NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_GroupOrders_order_statuses_idx` (`order_statuses_status_code` ASC) VISIBLE,
  INDEX `fk_GroupOrders_Students1_idx` (`Students_organizer_id` ASC) VISIBLE,
  CONSTRAINT `fk_GroupOrders_order_statuses`
    FOREIGN KEY (`order_statuses_status_code`)
    REFERENCES `pjtdb`.`order_statuses` (`status_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GroupOrders_Students1`
    FOREIGN KEY (`Students_organizer_id`)
    REFERENCES `pjtdb`.`Students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`order_statuses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`order_statuses` (
  `status_code` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`status_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`jacket_colors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`jacket_colors` (
  `color_id` INT NOT NULL,
  `color_name` VARCHAR(45) NULL,
  PRIMARY KEY (`color_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`jacket_sizes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`jacket_sizes` (
  `size_id` INT NOT NULL,
  `size_label` VARCHAR(45) NULL,
  PRIMARY KEY (`size_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`patch_designs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`patch_designs` (
  `design_id` INT NOT NULL,
  `design_name` VARCHAR(45) NULL,
  PRIMARY KEY (`design_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`jackets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`jackets` (
  `jacket_id` INT NOT NULL,
  `base_price` DECIMAL(20,2) NULL,
  `jacket_colors_color_id` INT NOT NULL,
  `jacket_sizes_size_id` INT NOT NULL,
  `patch_designs_design_id` INT NOT NULL,
  PRIMARY KEY (`jacket_id`),
  INDEX `fk_jackets_jacket_sizes1_idx` (`jacket_colors_color_id` ASC) VISIBLE,
  INDEX `fk_jackets_jacket_sizes2_idx` (`jacket_sizes_size_id` ASC) VISIBLE,
  INDEX `fk_jackets_patch_designs1_idx` (`patch_designs_design_id` ASC) VISIBLE,
  CONSTRAINT `fk_jackets_jacket_sizes1`
    FOREIGN KEY (`jacket_colors_color_id`)
    REFERENCES `pjtdb`.`jacket_colors` (`color_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_jackets_jacket_sizes2`
    FOREIGN KEY (`jacket_sizes_size_id`)
    REFERENCES `pjtdb`.`jacket_sizes` (`size_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_jackets_patch_designs1`
    FOREIGN KEY (`patch_designs_design_id`)
    REFERENCES `pjtdb`.`patch_designs` (`design_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`item_statuses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`item_statuses` (
  `status_code` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`status_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`order_items` (
  `item_id` INT NOT NULL,
  `quantity` INT NULL,
  `unit_price` DECIMAL(10,2) NULL,
  `Students_student_id` INT NOT NULL,
  `jackets_jacket_id` INT NOT NULL,
  `item_statuses_status_code` VARCHAR(20) NOT NULL,
  `GroupOrders_order_id` INT NOT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `fk_order_items_Students1_idx` (`Students_student_id` ASC) VISIBLE,
  INDEX `fk_order_items_jackets1_idx` (`jackets_jacket_id` ASC) VISIBLE,
  INDEX `fk_order_items_item_statuses1_idx` (`item_statuses_status_code` ASC) VISIBLE,
  INDEX `fk_order_items_GroupOrders1_idx` (`GroupOrders_order_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_items_Students1`
    FOREIGN KEY (`Students_student_id`)
    REFERENCES `pjtdb`.`Students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_items_jackets1`
    FOREIGN KEY (`jackets_jacket_id`)
    REFERENCES `pjtdb`.`jackets` (`jacket_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_items_item_statuses1`
    FOREIGN KEY (`item_statuses_status_code`)
    REFERENCES `pjtdb`.`item_statuses` (`status_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_items_GroupOrders1`
    FOREIGN KEY (`GroupOrders_order_id`)
    REFERENCES `pjtdb`.`GroupOrders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`payment_methods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`payment_methods` (
  `method_code` INT NOT NULL,
  PRIMARY KEY (`method_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pjtdb`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pjtdb`.`payments` (
  `payment_id` INT NOT NULL,
  `installment_no` INT NULL,
  `amount` DECIMAL(20) NULL,
  `paid_at` DATETIME NULL,
  `payment_methods_method_code` INT NOT NULL,
  `order_items_item_id` INT NOT NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `fk_payments_payment_methods1_idx` (`payment_methods_method_code` ASC) VISIBLE,
  INDEX `fk_payments_order_items1_idx` (`order_items_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_payments_payment_methods1`
    FOREIGN KEY (`payment_methods_method_code`)
    REFERENCES `pjtdb`.`payment_methods` (`method_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payments_order_items1`
    FOREIGN KEY (`order_items_item_id`)
    REFERENCES `pjtdb`.`order_items` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

/* ──────────────────────────────────────────────────────────────
   뷰: 주문-학생-자켓 요약 (vw_order_summary)
   필요성: 6-테이블 JOIN 을 캡슐화하여 프론트/리포트 쿼리 길이를 단축
────────────────────────────────────────────────────────────── */
CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
    oi.item_id,
    go.title                         AS order_title,
    s.name                           AS student_name,
    jc.color_name,
    js.size_label,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price      AS total_price,
    go.order_statuses_status_code    AS order_status,
    oi.item_statuses_status_code     AS item_status,
    go.deadline,
    go.vendor
FROM pjtdb.order_items   oi
JOIN pjtdb.GroupOrders   go ON go.order_id       = oi.GroupOrders_order_id
JOIN pjtdb.Students      s  ON s.student_id      = oi.Students_student_id
JOIN pjtdb.jackets       j  ON j.jacket_id       = oi.jackets_jacket_id
JOIN pjtdb.jacket_colors jc ON jc.color_id       = j.jacket_colors_color_id
JOIN pjtdb.jacket_sizes  js ON js.size_id        = j.jacket_sizes_size_id;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
