   DELIMITER //
   CREATE PROCEDURE sp_ListarAutores()
   BEGIN
       SELECT * FROM Autor;
   END //
   DELIMITER ;

   CALL sp_ListarAutores();

DELIMITER //
   CREATE PROCEDURE sp_LivrosPorCategoria(IN categoriaNome VARCHAR(100))
   BEGIN
       SELECT Livro.Titulo
       FROM Livro
       INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
       WHERE Categoria.Nome = categoriaNome;
   END //
   DELIMITER ;

   CALL sp_LivrosPorCategoria('Romance');
