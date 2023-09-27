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

DELIMITER //
   CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoriaNome VARCHAR(100), OUT totalLivros INT)
   BEGIN
       SELECT COUNT(*) INTO totalLivros
       FROM Livro
       INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
       WHERE Categoria.Nome = categoriaNome;
   END //
   DELIMITER ;

CALL sp_ContarLivrosPorCategoria('Ficção Científica', @total);
   SELECT @total;

DELIMITER //
   CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoriaNome VARCHAR(100), OUT possuiLivros BOOL)
   BEGIN
       SELECT EXISTS (
           SELECT 1
           FROM Livro
           INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
           WHERE Categoria.Nome = categoriaNome
       ) INTO possuiLivros;
   END //
   DELIMITER ;

CALL sp_VerificarLivrosCategoria('História', @possui);
   SELECT @possui;

DELIMITER //
   CREATE PROCEDURE sp_LivrosAteAno(IN anoPublicacao INT)
   BEGIN
       SELECT * FROM Livro WHERE Ano_Publicacao <= anoPublicacao;
   END //
   DELIMITER ;

   CALL sp_LivrosAteAno(2010);

DELIMITER //
   CREATE PROCEDURE sp_TitulosPorCategoria(IN categoriaNome VARCHAR(100))
   BEGIN
       DECLARE done INT DEFAULT FALSE;
       DECLARE livroTitulo VARCHAR(255);

       DECLARE cur CURSOR FOR
           SELECT Livro.Titulo
           FROM Livro
           INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
           WHERE Categoria.Nome = categoriaNome;

       DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

       OPEN cur;
       read_loop: LOOP
           FETCH cur INTO livroTitulo;
           IF done THEN
               LEAVE read_loop;
           END IF;
           SELECT livroTitulo;
       END LOOP;

       CLOSE cur;
   END //
   DELIMITER ;

   CALL sp_TitulosPorCategoria('Ciência');
