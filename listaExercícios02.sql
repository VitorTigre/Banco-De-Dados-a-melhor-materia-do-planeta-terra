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

DELIMITER //
   CREATE PROCEDURE sp_AdicionarLivro(
       IN tituloLivro VARCHAR(255),
       IN editoraID INT,
       IN anoPublicacao INT,
       IN numPaginas INT,
       IN categoriaID INT,
       OUT mensagem VARCHAR(255)
   )
   BEGIN
       DECLARE EXIT HANDLER FOR SQLEXCEPTION
       BEGIN
           ROLLBACK;
           SET mensagem = 'Erro ao adicionar o livro. Verifique os dados.';
       END;

       START TRANSACTION;

       -- Verifique se o título já existe
       SELECT COUNT(*) INTO @livroExistente
       FROM Livro
       WHERE Titulo = tituloLivro;

       IF @livroExistente > 0 THEN
           SET mensagem = 'O livro com o mesmo título já existe.';
           ROLLBACK;
       ELSE
           -- Inserir o novo livro
           INSERT INTO Livro (Titulo, Editora_ID, Ano_Publicacao, Numero_Paginas, Categoria_ID)
           VALUES (tituloLivro, editoraID, anoPublicacao, numPaginas, categoriaID);

           COMMIT;
           SET mensagem = 'Livro adicionado com sucesso.';
       END IF;
   END //
   DELIMITER ;

   CALL sp_AdicionarLivro('Novo Livro', 1, 2023, 250, 2, @mensagem);
   SELECT @mensagem;

DELIMITER //
   CREATE PROCEDURE sp_AutorMaisAntigo(OUT nomeAutorMaisAntigo VARCHAR(255))
   BEGIN
       SELECT CONCAT(Nome, ' ', Sobrenome) INTO nomeAutorMaisAntigo
       FROM Autor
       ORDER BY Data_Nascimento
       LIMIT 1;
   END //
   DELIMITER ;

   CALL sp_AutorMaisAntigo(@autorMaisAntigo);
   SELECT @autorMaisAntigo;
   
DELIMITER //
CREATE PROCEDURE sp_ListarAutoresNovo()
BEGIN
    SELECT * FROM Autor;
END //
DELIMITER ;

CALL sp_ListarAutoresNovo();
