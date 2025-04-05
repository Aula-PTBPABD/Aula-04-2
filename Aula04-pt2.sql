/*Selecionando ID e nome dos instrutores e criando um count para somar as seções dos professores baseadas no ID da tabela teaches*/
/*Usando LEFT OUTER JOIN*/
SELECT
instructor.ID,
instructor.name,
count(teaches.ID) AS "Number_of_Sections"
FROM instructor
LEFT OUTER JOIN teaches ON instructor.ID = teaches.ID
GROUP BY
instructor.ID,
instructor.name

/*Usando uma subconsulta*/
SELECT
instructor.ID,
instructor.name,
	(SELECT count(teaches.ID)
	FROM teaches
	WHERE teaches.ID = instructor.ID)
FROM instructor

/*Usando dois JOINS para fazer a relação das tabelas, section, teaches e instructor, e usando o COALESCE para que ao invés de null apareça '-'*/
SELECT 
s.course_id,
s.sec_id,
instructor.ID,
s.semester,
s.year,
COALESCE(instructor.name, '-') AS "name"
FROM section s
LEFT JOIN
teaches ON s.course_id = teaches.course_id
AND s.sec_id = teaches.sec_id
AND s.semester = teaches.semester
AND s.year = teaches.year
LEFT JOIN
instructor ON teaches.ID = instructor.ID
WHERE 
s.semester = 'Spring' AND s.year = 2010

/*Fazendo a relação grade_points e criando uma view para facilitar a consulta posteriormente*/
CREATE VIEW pontos_por_curso AS
SELECT 
student.ID,
student.name,
course.title,
course.dept_name,
takes.grade,
CASE
        WHEN grade = 'A+' THEN 4.0
        WHEN grade = 'A'  THEN 3.7
        WHEN grade = 'A-' THEN 3.4
        WHEN grade = 'B+' THEN 3.1
        WHEN grade = 'B'  THEN 2.7
        WHEN grade = 'B-' THEN 2.3
        WHEN grade = 'C+' THEN 2.0
        WHEN grade = 'C'  THEN 1.7
        WHEN grade = 'C-' THEN 1.3
        WHEN grade = 'D'  THEN 1.0
        WHEN grade = 'F'  THEN 0.0
        ELSE NULL
    END AS points,
course.credits,
course.credits* 
CASE
        WHEN grade = 'A+' THEN 4.0
        WHEN grade = 'A'  THEN 3.7
        WHEN grade = 'A-' THEN 3.4
        WHEN grade = 'B+' THEN 3.1
        WHEN grade = 'B'  THEN 2.7
        WHEN grade = 'B-' THEN 2.3
        WHEN grade = 'C+' THEN 2.0
        WHEN grade = 'C'  THEN 1.7
        WHEN grade = 'C-' THEN 1.3
        WHEN grade = 'D'  THEN 1.0
        WHEN grade = 'F'  THEN 0.0
        ELSE NULL
        END AS 'pontos_curso'
FROM student
LEFT JOIN
takes ON student.ID = takes.ID
LEFT JOIN 
course ON takes.course_id = course.course_id

/*Usando a view criada anteriormente para fazer a soma dos pontos totais de cada aluno*/
CREATE VIEW coeficiente_rendimento AS
SELECT 
ID,
name,
SUM(pontos_curso) AS 'Pontos_Totais'
FROM pontos_por_curso
GROUP BY
ID, 
name

