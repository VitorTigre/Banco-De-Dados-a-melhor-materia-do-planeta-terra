   DELIMITER //
   CREATE PROCEDURE sp_ListarAutores()
   BEGIN
       SELECT * FROM Autor;
   END //
   DELIMITER ;

   CALL sp_ListarAutores();
