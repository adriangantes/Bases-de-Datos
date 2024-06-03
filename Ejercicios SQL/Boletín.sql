

/* BOLETÍN */

--1--
SELECT *
FROM alumno
WHERE email NOT IN (SELECT email FROM MEN_FORO
WHERE email IS NOT null)

--2--
SELECT p.nome
FROM profesor p JOIN men_foro m ON p.nss = m.NSS 
GROUP BY p.nss, p.nome
HAVING count(*) >= ALL (
	SELECT count(*) 
	FROM men_foro 
	WHERE nss IS NOT NULL
	GROUP BY nss)
	
--3--
SELECT p.nome, c.cod_c, c.NOME , horas
FROM profesor p LEFT JOIN capacitado ca ON p.NSS = ca.NSS 
	LEFT JOIN curso c ON ca.cod_c = c.cod_c
WHERE horas = (SELECT max(horas) 
				FROM capacitado ca1 JOIN curso c1 ON ca1.cod_c = c1.cod_c
				WHERE ca1.nss = ca.nss)
	
--4--
SELECT c.cod_c, nome, e.numero, TO_CHAR(data_comezo, 'YYYY'), count(*)
FROM edicion e JOIN curso c ON e.COD_C = c.COD_C 
	JOIN rexistrase r ON r.COD_C = e.COD_C  AND  r.NUMERO = e.NUMERO 
GROUP BY c.COD_C, nome, e.numero, data_comezo
	
--5--
SELECT c.cod_c, nome, prezo, data_comezo
FROM edicion e RIGHT JOIN curso c ON e.cod_c = c.cod_c
AND prezo > 100

--6--
SELECT c.cod_c, nome, numero
FROM rexistrase r JOIN curso c ON r.cod_c = c.cod_c
GROUP BY c.cod_c, numero, nome
HAVING count(*) = (SELECT max(count(*))
					FROM rexistrase r1
					WHERE c.COD_C = r1.cod_c
					GROUP BY r1.numero)

--7--
SELECT c.cod_c, nome, metpago
FROM curso c JOIN REXISTRASE r ON c.COD_C = r.COD_C
GROUP BY c.cod_c, nome, metpago
HAVING count(*) = (SELECT max(count(*))
					FROM REXISTRASE
					WHERE COD_C = c.COD_C 
					GROUP BY COD_C, metpago)

--8--
SELECT c.cod_c, numero, nome, prezo
FROM edicion e RIGHT JOIN curso c ON e.cod_c = c.cod_c
WHERE prezo = (SELECT max(prezo) FROM edicion
				WHERE cod_c = c.cod_c)

--9--
SELECT t.id_tema, t.asunto, count(*)
FROM tema t JOIN pertenece p ON t.ID_TEMA = p.id_tema
	JOIN MEN_FORO m ON p.ID_MEN = m.ID_MEN
WHERE m.id_men NOT IN (SELECT resposta_de
 						FROM men_foro
						WHERE resposta_de IS NOT NULL)
GROUP BY t.ID_TEMA, t.asunto
HAVING count(*) = (SELECT min(count(*))
					FROM pertenece p1 JOIN men_foro m1
						ON p1.id_men = m1.id_men
					WHERE  m1.id_men NOT IN 
						(SELECT resposta_de
 						FROM men_foro
						WHERE resposta_de IS NOT NULL)
					GROUP BY p1.id_tema)

--10--
SELECT e.cod_c, nome, e.numero, count(r.email)
FROM curso c right JOIN edicion e ON c.COD_C = e.COD_C 
	LEFT JOIN rexistrase r ON c.COD_C = r.cod_c AND e.NUMERO = r.NUMERO 
GROUP BY e.COD_C, nome, e.numero
HAVING count(r.email) = (SELECT min(count(r1.email))
					FROM REXISTRASE r1 RIGHT JOIN edicion e1 ON e1.COD_C = r1.cod_c AND e1.NUMERO = r1.NUMERO 
					GROUP BY e1.cod_c, e1.numero)

--11--
SELECT a.nome, t.asunto, t.cod_c
FROM alumno a JOIN men_foro m ON a.EMAIL = m.email
	JOIN pertenece p ON m.ID_MEN = p.ID_MEN 
	JOIN tema t ON p.ID_TEMA = t.ID_TEMA 
WHERE a.email NOT IN (SELECT EMAIL FROM REXISTRASE WHERE cod_c = t.cod_c)

--12--
SELECT p.nome, t.asunto, count(m.ID_MEN)
FROM profesor p JOIN men_foro m ON p.nss = m.nss
	JOIN pertenece p ON m.ID_MEN = p.ID_MEN 
	RIGHT JOIN tema t ON p.ID_TEMA = t.ID_TEMA 
WHERE m.nss IS NOT null
GROUP BY p.nome, t.ASUNTO, t.ID_TEMA 
HAVING count(m.ID_MEN) = (SELECT max(count(m1.id_men))
							FROM PERTENECE p1 JOIN MEN_FORO m1 ON p1.id_men = m1.id_men
							WHERE nss IS NOT NULL AND p1.id_tema = t.ID_TEMA 
							GROUP BY nss)
							
--13--
SELECT avg(count(id_men))
FROM MEN_FORO 
GROUP BY to_char(DATA, 'DD/MM/YYYY')

--14--
SELECT avg(count(numero))
FROM curso c LEFT JOIN edicion e ON c.COD_C = e.COD_C 
GROUP BY c.COD_C 

--15--
SELECT m.data, count(r.id_men)
FROM men_foro m left JOIN MEN_FORO r ON r.RESPOSTA_DE = m.ID_MEN AND r.DATA = m.DATA
GROUP BY m.data

--16--
SELECT avg(media)
FROM (SELECT count(r.id_men) media
	FROM men_foro m left JOIN MEN_FORO r ON r.RESPOSTA_DE = m.ID_MEN AND r.DATA = m.DATA
	GROUP BY m.data)

--17--
SELECT a.email, nome, count(DISTINCT p.id_tema) temas, count(DISTINCT m.id_men) mensajes
FROM alumno a LEFT JOIN men_foro m ON a.EMAIL = m.EMAIL 
	LEFT JOIN pertenece p ON m.ID_MEN = p.ID_MEN 
GROUP BY a.email, nome

--18--
SELECT c.cod_c, nome, e.numero, count(DISTINCT t.id_tema) temas, count(DISTINCT p.id_men) mensajes
FROM curso c RIGHT JOIN edicion e ON e.COD_C = c.COD_C
	LEFT JOIN tema t ON t.COD_C = e.COD_C  AND t.NUMERO = e.NUMERO
	LEFT JOIN pertenece p ON p.ID_TEMA = t.ID_TEMA
GROUP BY c.cod_c, nome, e.numero

--19--
SELECT c1.nome, count(c.cod_c)
FROM curso c RIGHT JOIN curso c1 ON c.requisito = c1.COD_C
	AND c.HORAS > c1.horas
WHERE c1.COD_C IN (SELECT requisito FROM curso)
GROUP BY c1.nome

--20--
SELECT t.asunto, a.nome
FROM tema t CROSS JOIN alumno a
WHERE (t.id_tema, a.email) NOT IN (SELECT t.id_tema, email 
									FROM men_foro NATURAL JOIN pertenece JOIN tema USING (id_tema)
									WHERE email IS NOT null)

--21--
SELECT t.asunto, a.nome
FROM tema t CROSS JOIN alumno a
WHERE (t.id_tema, a.email) NOT IN (SELECT t.id_tema, email 
									FROM men_foro NATURAL JOIN pertenece JOIN tema USING (id_tema)
									WHERE email IS NOT null)
UNION 
SELECT t.asunto,p.nome
FROM tema t CROSS JOIN profesor p
WHERE (t.id_tema, p.nss) NOT IN (SELECT t.id_tema, nss
									FROM men_foro NATURAL JOIN pertenece JOIN tema USING (id_tema)
									WHERE nss IS NOT null)

--22--
SELECT DISTINCT cod_c
FROM EDICION 
WHERE cod_c NOT IN (SELECT COD_C
					FROM REXISTRASE
					GROUP BY cod_c, NUMERO
					HAVING count(email) <= 2)

--23--
SELECT nss, nome
FROM profesor 
WHERE nss NOT IN (
	SELECT DISTINCT nss FROM
		(SELECT nss, cod_c FROM profesor CROSS JOIN curso
		MINUS 
		SELECT nss, cod_c FROM capacitado))
		
--24--
SELECT nss, nome
FROM profesor 
WHERE nss IN (
	SELECT DISTINCT nss FROM
		(SELECT nss, cod_c FROM profesor CROSS JOIN curso
		MINUS 
		SELECT nss, cod_c FROM capacitado))

--25--
SELECT ca.nss, p.nome, ca.cod_c, c.nome, 'NO' FROM (
		SELECT nss, cod_c FROM profesor CROSS JOIN curso
		MINUS SELECT nss, cod_c FROM capacitado) ca 
	JOIN profesor p ON ca.nss = p.nss
	JOIN curso c ON ca.cod_c = c.cod_c
UNION 
SELECT ca.nss, p.nome, ca.cod_c, c.nome, 'SI' FROM capacitado ca
	JOIN profesor p ON ca.nss = p.nss
	JOIN curso c ON ca.cod_c = c.cod_c

--26--
SELECT c.cod_c, c.nome, COUNT(DISTINCT e.numero) caros, COUNT(r.email) matriculados
FROM curso c LEFT JOIN edicion e ON c.cod_c = e.cod_c AND e.prezo > 100
	LEFT JOIN rexistrase r ON e.cod_c = r.cod_c AND e.numero = r.numero
GROUP BY c.cod_c, c.nome

--27--
SELECT c.nome, e.cod_c, e.numero, count(DISTINCT r.email) alumnos, count(DISTINCT t.id_tema) temas
FROM curso c RIGHT JOIN edicion e ON e.COD_C = c.COD_C 
	LEFT JOIN rexistrase r ON e.cod_c = r.cod_c AND e.numero = r.numero
	LEFT JOIN tema t ON e.cod_c = t.cod_c AND e.numero = t.numero
GROUP BY c.nome, e.COD_C, e.NUMERO 
	
--28--
SELECT p.nome, count(m.id_men)
FROM profesor p LEFT JOIN men_foro m ON p.nss = m.nss
	LEFT JOIN pertenece p ON m.id_men = p.id_men
	LEFT JOIN tema t ON p.id_tema = t.id_tema
	LEFT JOIN edicion e ON e.cod_c = t.cod_c AND e.numero = t.numero AND  e.nss = p.nss
GROUP BY p.NOME 

--29--
SELECT e.cod_c, e.numero, count(m.id_men)
FROM edicion e LEFT JOIN tema t ON e.cod_c = t.cod_c AND e.numero = t.numero
	LEFT JOIN pertenece p ON t.id_tema = p.ID_TEMA 
	LEFT JOIN men_foro m ON p.ID_MEN = m.id_men AND m.DATA >= e.DATA_COMEZO AND m.DATA <= E.DATA_FIN
GROUP BY E.COD_C, e.numero

--30--
SELECT e.cod_c, e.numero, p.nome, to_char(data_alta, 'YYYY') - antig AS diferencia
FROM profesor p JOIN edicion e ON p.nss = e.NSS
	JOIN (SELECT e1.cod_c, min(to_char(data_alta, 'YYYY')) antig
			FROM profesor p1 JOIN edicion e1 ON p1.nss = e1.nss
			GROUP BY e1.cod_c) a ON a.cod_c = e.cod_c

--31--
SELECT a.nome alum, c.nome cur, 'SI' matriculado
FROM alumno a JOIN rexistrase r ON a.EMAIL = r.EMAIL 
	JOIN curso c ON r.COD_C = c.COD_C 
UNION 
SELECT a.nome alum, c.nome cur, 'NO' matriculado
FROM alumno a CROSS JOIN curso c
WHERE (a.nome, c.nome) NOT IN (
		SELECT a.nome, c.nome
		FROM alumno a JOIN rexistrase r ON a.EMAIL = r.EMAIL 
		JOIN curso c ON r.COD_C = c.COD_C
		)
ORDER BY alum, cur
			
--32--			
SELECT c.nome, e.numero, count(DISTINCT m.id_men)
FROM curso c JOIN edicion e ON c.COD_C = e.cod_c
	JOIN tema t ON e.cod_c = t.COD_C AND e.NUMERO = t.NUMERO 
	JOIN pertenece p ON t.ID_TEMA = p.ID_TEMA 
	JOIN men_foro m ON p.ID_MEN = m.ID_MEN AND m.nss IS NULL 
	JOIN men_foro r ON m.id_men = r.RESPOSTA_DE AND r.email IS null
GROUP BY c.nome, e.numero

--33--		
SELECT t.asunto, alum, prof
FROM tema t JOIN (
		SELECT id_tema, count(*) alum
		FROM men_foro m JOIN men_foro r ON r.resposta_de = m.id_men
			JOIN pertenece p ON m.id_men = p.id_men
		WHERE m.nss IS NULL AND r.nss IS NOT NULL
		GROUP BY id_tema) ma ON t.ID_TEMA = ma.id_tema
	JOIN (
		SELECT id_tema, count(*) prof
		FROM men_foro m JOIN men_foro r ON r.resposta_de = m.id_men
			JOIN pertenece p ON m.id_men = p.id_men
		WHERE m.email IS NULL AND r.email IS NOT NULL
		GROUP BY id_tema) mp ON t.ID_TEMA = mp.id_tema

--34--
SELECT email
FROM rexistrase r JOIN edicion e ON r.COD_C = e.COD_C AND r.numero = e.NUMERO 
WHERE 3 <= (
		SELECT count(*)
 		FROM rexistrase r1 JOIN edicion e1 ON r1.cod_c=e1.cod_c AND r1.numero=e1.numero
		WHERE r1.email=r.email AND ((e1.data_comezo <= e.data_fin) AND (e1.data_fin >= e.data_comezo)))
GROUP BY email
			
--35--
SELECT a.email, a.nome, a.ORGANIZACION, avg(prezo) media, org - avg(prezo) diferencia
FROM alumno a JOIN rexistrase r ON a.email = r.EMAIL 
	JOIN edicion e ON r.COD_C = e.COD_C AND r.numero = e.numero
	JOIN (
			SELECT ORGANIZACION, avg(prezo) org
			FROM alumno a1 JOIN rexistrase r1 ON a1.email = r1.email
				JOIN edicion e1 ON r1.COD_C = e1.COD_C AND r1.numero = e1.numero
			GROUP BY ORGANIZACION) o ON a.ORGANIZACION = o.organizacion
GROUP BY a.email, a.nome, org, a.ORGANIZACION 
	
--36--
SELECT tran, tar, abs(tran - tar) diferencia
FROM (
		SELECT avg(prezo) tran
		FROM rexistrase r JOIN edicion e ON r.COD_C = e.COD_C AND r.numero = e.numero
		WHERE metpago = 'transferencia')
	CROSS JOIN (
		SELECT avg(prezo) tar
		FROM rexistrase r JOIN edicion e ON r.COD_C = e.COD_C AND r.numero = e.numero
		WHERE metpago = 'tarxeta')
	
--37--
SELECT a.email, a.nome, avg(prezo) media, total - avg(prezo) diferencia
FROM alumno a LEFT JOIN rexistrase r ON a.email = r.EMAIL 
	LEFT JOIN edicion e ON r.COD_C = e.COD_C AND r.numero = e.numero
	CROSS JOIN (
		SELECT avg(prezo) total
		FROM alumno a JOIN rexistrase r ON a.email = r.EMAIL 
		JOIN edicion e ON r.COD_C = e.COD_C AND r.numero = e.numero)
GROUP BY a.email, a.nome, total

	
	
	
	
	