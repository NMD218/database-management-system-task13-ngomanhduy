-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: mydb
-- ------------------------------------------------------
-- Server version	8.4.7

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bankaccounts`
--

DROP TABLE IF EXISTS `bankaccounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bankaccounts` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(50) NOT NULL,
  `balance` decimal(15,2) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `fk_BankAccounts_Users_idx` (`user_id`),
  CONSTRAINT `fk_BankAccounts_Users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bankaccounts`
--

LOCK TABLES `bankaccounts` WRITE;
/*!40000 ALTER TABLE `bankaccounts` DISABLE KEYS */;
INSERT INTO `bankaccounts` VALUES (1,'Techcombank',600000000.00,1),(2,'Momo',120000000.00,2),(3,'Vietcombank',150000000.00,3),(4,'MBBank',500000000.00,4),(5,'TPBank',840000000.00,5),(66,'Techcombank',600000000.00,1),(67,'Momo',120000000.00,2),(68,'Vietcombank',150000000.00,3),(69,'MBBank',500000000.00,4),(70,'TPBank',840000000.00,5),(71,'Techcombank',600000000.00,1),(72,'Momo',120000000.00,2),(73,'Vietcombank',150000000.00,3),(74,'MBBank',500000000.00,4),(75,'TPBank',840000000.00,5),(76,'Techcombank',600000000.00,1),(77,'Momo',120000000.00,2),(78,'Vietcombank',150000000.00,3),(79,'MBBank',500000000.00,4),(80,'TPBank',840000000.00,5);
/*!40000 ALTER TABLE `bankaccounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expensecategories`
--

DROP TABLE IF EXISTS `expensecategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expensecategories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expensecategories`
--

LOCK TABLES `expensecategories` WRITE;
/*!40000 ALTER TABLE `expensecategories` DISABLE KEYS */;
INSERT INTO `expensecategories` VALUES (1,'Food & Dining'),(2,'Transportation'),(3,'Education & Books'),(4,'Utilities & Bills'),(5,'Entertainment & Shopping'),(81,'Games');
/*!40000 ALTER TABLE `expensecategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `expense_id` int NOT NULL AUTO_INCREMENT,
  `amount` decimal(15,2) NOT NULL,
  `expense_date` date NOT NULL,
  `description` varchar(255) NOT NULL,
  `user_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`expense_id`),
  KEY `fk_Expenses_Users1_idx` (`user_id`),
  KEY `fk_Expenses_ExpenseCategories1_idx` (`category_id`),
  KEY `idx_expense_category` (`category_id`),
  CONSTRAINT `fk_Expenses_ExpenseCategories1` FOREIGN KEY (`category_id`) REFERENCES `expensecategories` (`category_id`),
  CONSTRAINT `fk_Expenses_Users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
INSERT INTO `expenses` VALUES (77,40.00,'2026-04-01','Eating',2,1),(78,250.00,'2026-04-01','Repairment',3,2),(114,40.00,'2026-04-01','Eating',1,1),(115,250.00,'2026-04-01','Repairment',2,2),(117,120.00,'2026-04-02','Watching movies',4,4),(118,350.00,'2026-03-30','Electricity bill',5,5),(135,50.00,'2026-05-13','',63,3),(136,100.00,'2026-05-13','',63,81);
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `income`
--

DROP TABLE IF EXISTS `income`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income` (
  `income_id` int NOT NULL AUTO_INCREMENT,
  `amount` decimal(15,2) NOT NULL,
  `income_date` date NOT NULL,
  `description` varchar(255) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`income_id`,`amount`,`income_date`),
  KEY `fk_Income_Users1_idx` (`user_id`),
  CONSTRAINT `fk_Income_Users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `income`
--

LOCK TABLES `income` WRITE;
/*!40000 ALTER TABLE `income` DISABLE KEYS */;
INSERT INTO `income` VALUES (81,12000000.00,'2026-03-25','Salary',4),(116,3000000.00,'2026-04-01','Commission',1),(118,12000000.00,'2026-03-25','Salary',3),(119,2000000.00,'2026-04-01','Award',4),(120,5000000.00,'2026-03-28','Bonus',5),(138,200.00,'2026-05-13','Award',63);
/*!40000 ALTER TABLE `income` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT '123456',
  PRIMARY KEY (`user_id`),
  KEY `idx_user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(2,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(3,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(4,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(5,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(6,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(7,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(8,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(9,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(10,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(11,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(12,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(13,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(14,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(15,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(16,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(17,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(18,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(19,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(20,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(21,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(22,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(23,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(24,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(25,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(26,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(27,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(28,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(29,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(30,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(31,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(32,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(33,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(34,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(35,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(36,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(37,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(38,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(39,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(40,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(42,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(43,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(44,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(45,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(46,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(47,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(48,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(49,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(50,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(51,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(52,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(53,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(54,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(55,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(56,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(57,'admin',NULL,NULL,'123456'),(58,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(59,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(60,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(61,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(62,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(63,'Ngô Mạnh Duy','duy.ngomanh@gmail.com','0912345678','duy123'),(64,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(65,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(66,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(67,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(68,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(69,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(70,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(71,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(72,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(73,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(74,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(75,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(76,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(77,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(78,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(79,'Elon Musk','elonmusk@gmail.com','0912345678','123456'),(80,'Taylor Swift','taylorswift@gmail.com','0987654321','123456'),(81,'Lionel Messi','leonelmessi@gmail.com','0901234567','123456'),(82,'Mark Zuckerberg','markzuckerberg@gmail.com','0934567890','123456'),(83,'Micheal Jackson','michealjackson@gmail.co','0978123456','123456'),(84,'admin','admin@mydb.com','0000000000','admin123'),(85,'Dương Đăng Khoa','duongdangkhoa@gmail.com','0472957483','khoa123');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `view_categoryspending`
--

DROP TABLE IF EXISTS `view_categoryspending`;
/*!50001 DROP VIEW IF EXISTS `view_categoryspending`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_categoryspending` AS SELECT 
 1 AS `User`,
 1 AS `Category`,
 1 AS `Payment`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `view_categoryspending`
--

/*!50001 DROP VIEW IF EXISTS `view_categoryspending`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_categoryspending` AS select `u`.`user_name` AS `User`,`ec`.`category_name` AS `Category`,sum(`e`.`amount`) AS `Payment` from ((`users` `u` join `expenses` `e` on((`u`.`user_id` = `e`.`user_id`))) join `expensecategories` `ec` on((`e`.`category_id` = `ec`.`category_id`))) group by `u`.`user_id`,`ec`.`category_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-13 23:20:24
