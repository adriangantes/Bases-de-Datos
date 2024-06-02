

--16--

--1--
SELECT ename, COALESCE (sum(hours), 0)
FROM emp e LEFT JOIN emppro ep ON e.empno = ep.empno
GROUP BY e.empno, ename

--2--
SELECT e.ename, j.ename, j.deptno
FROM emp e left JOIN emp j ON e.mgr = j.EMPNO 

--3--
SELECT j.ename, count(*)
FROM emp e JOIN emp j ON e.mgr = j.EMPNO 
GROUP BY j.ename

--4--
SELECT pname, sum(hours)
FROM emppro ep JOIN pro p ON ep.prono = p.PRONO 
GROUP BY pname
HAVING sum(hours) > 15

--5--
SELECT distinct dname, job
FROM emp e JOIN dept d ON e.DEPTNO = d.DEPTNO 
GROUP BY dname, job
HAVING count(*) >= 2

--6--
SELECT pname, ename, hours
FROM emp e JOIN emppro ep ON e.empno = ep.EMPNO 
	JOIN pro p ON ep.PRONO = p.PRONO 
WHERE hours = (SELECT max(hours) FROM emppro
				WHERE prono = ep.PRONO)
				
--7--
SELECT j.ename, sum(e.sal)
FROM emp e JOIN emp j ON e.mgr = j.EMPNO 
GROUP BY j.ENAME 
HAVING sum(e.sal) = (SELECT max(sum(sal)) FROM emp 
					GROUP BY mgr)

--8--
SELECT p.prono, deptno, sum(hours)
FROM pro p JOIN emppro ep ON p.PRONO = ep.PRONO 
GROUP BY p.PRONO, p.DEPTNO 
HAVING sum(hours) = (SELECT max(sum(hours)) 
					FROM emppro ep1 JOIN pro p1 ON ep1.prono = p1.prono
					WHERE p1.deptno = p.DEPTNO 
					GROUP BY ep1.prono, p1.deptno)
					
					
					
--41--

--1--
SELECT dname, COALESCE (count(empno), 0) empleados
FROM dept d LEFT JOIN emp e ON d.deptno = e.DEPTNO 
GROUP BY dname

--2--
SELECT ename, COALESCE (sum(hours), 0) horas
FROM emp e LEFT JOIN emppro ep ON e.EMPNO = ep.EMPNO 
GROUP BY ENAME 

--3--
SELECT e.ename, j.ename, dname
FROM emp e LEFT JOIN emp j ON e.mgr = j.empno
	LEFT JOIN dept d ON j.deptno = d.deptno 

--4--
SELECT ename, COALESCE (count(loc), 0)
FROM emp e left JOIN emppro ep ON e.EMPNO = ep.EMPNO 
	LEFT JOIN pro p ON ep.PRONO = p.PRONO 
GROUP BY ename

--5--
SELECT d.deptno, dname, count(DISTINCT empno) empleados
FROM pro p full JOIN dept d ON p.DEPTNO = d.DEPTNO 
	FULL JOIN emppro ep ON ep.PRONO = p.PRONO 
WHERE d.deptno = 30 OR d.deptno = 40
GROUP BY d.deptno, dname



--43--

--1--
SELECT j.ename, COUNT(e.ename)
FROM emp e RIGHT JOIN emp j ON e.mgr = j.empno
	AND TO_CHAR(e.hiredate, 'YYYY') = TO_CHAR(j.hiredate, 'YYYY')
WHERE j.empno IN (SELECT mgr FROM emp)
GROUP BY j.empno, j.ename 

--2--
SELECT DISTINCT ename, p.LOC, d.deptno
FROM emppro ep JOIN pro p on ep.prono = p.PRONO 
	JOIN dept d ON d.DEPTNO = p.DEPTNO
	JOIN emp e ON e.empno = ep.EMPNO 
WHERE d.loc = p.loc

--3--
SELECT DISTINCT e.ename, p.LOC, d.deptno, count(p.prono)
FROM emppro ep full JOIN pro p on ep.prono = p.PRONO 
	FULL JOIN dept d ON d.DEPTNO = p.DEPTNO
	full JOIN emp e ON e.empno = ep.EMPNO 
	AND d.loc = p.loc
GROUP BY e.ename, p.loc, d.DEPTNO 
HAVING e.ENAME IS NOT null

--4--
Select ename, count(p.prono)
from emp e join dept de on e.deptno=de.deptno
	left join emppro ep on e.empno=ep.empno
	left join pro p on ep.prono=p.prono
	and de.loc=p.loc
group by e.empno, ename


--49--

--1--
SELECT ename, sal, (SELECT avg(sal) FROM emp) "salario medio"
FROM emp
WHERE sal > (SELECT avg(sal) FROM emp)

--2--
SELECT ename, sal, deptno, salario_medio
FROM emp JOIN (SELECT deptno depart, avg(sal) salario_medio
				 FROM EMP GROUP BY deptno)
	ON deptno = depart
WHERE sal > salario_medio

--3--
SELECT empno, hours, prono
FROM emppro p
WHERE p.hours = (SELECT max(hours) FROM emppro
				WHERE prono = p.prono)

--4--
SELECT loc, e.ename, sum(hours)
FROM emp e JOIN emppro ep ON e.EMPNO = ep.EMPNO JOIN pro p ON ep.prono = p.PRONO 
GROUP BY e.ename, loc 
HAVING sum(hours) = (SELECT max(sum(hours))
					FROM pro p1 JOIN emppro ep1 ON ep1.prono = p1.prono
					WHERE loc = p.LOC
					GROUP BY ep1.empno)

--5--
SELECT avg(horas)
FROM (SELECT sum(hours) horas
		FROM emppro
		GROUP BY prono)
	

--6--
SELECT prono, sum(hours)
FROM emppro
GROUP BY prono
HAVING sum(hours) > (SELECT avg(horas)
					FROM (SELECT sum(hours) horas
							FROM emppro
							GROUP BY prono))
							
							

--51--

--1--
SELECT e.ename, max_sal - e.sal
FROM emp e JOIN (SELECT max(sal) max_sal, deptno depart
				FROM emp GROUP BY deptno)
	ON e.DEPTNO = depart

--2--
SELECT deptno, (SELECT max(sum(sal)) max_sal 
				FROM emp GROUP BY deptno) - sum(sal) diferencia
FROM emp
GROUP BY DEPTNO

--3--
SELECT empno, LOC
FROM emppro natural JOIN pro

--4--
SELECT DISTINCT empno, LOC
FROM emppro ep CROSS JOIN pro p
WHERE (empno, loc) NOT IN 
		(SELECT empno, LOC
		FROM emppro natural JOIN pro)

--5--
SELECT DISTINCT ename, LOC
FROM emp e CROSS JOIN pro p 
WHERE (e.empno, loc) NOT IN 
		(SELECT empno, LOC
		FROM emppro natural JOIN pro)

--6--
SELECT ename, LOC, 'SI' trabajo
FROM emp NATURAL JOIN emppro JOIN pro USING (prono)

UNION 

SELECT DISTINCT ename, LOC, 'NO'
FROM emp e LEFT JOIN emppro ep ON e.EMPNO = ep.empno
	CROSS JOIN pro p 
WHERE (e.empno, loc) NOT IN 
		(SELECT empno, LOC
		FROM emppro natural JOIN pro)

--7--
SELECT e.empno,e.ename,j.empno, j.ename
FROM emp e JOIN emp j ON e.mgr=j.empno

--8--
SELECT e.empno,e.ename,j.empno, j.ename
FROM emp e CROSS JOIN emp J
WHERE e.empno != j.EMPNO 
AND (e.empno, j.empno) NOT IN 
		(SELECT e.empno,j.empno
		FROM emp e JOIN emp j ON e.mgr=j.empno
		UNION
		SELECT j.empno, e.empno
		FROM emp e JOIN emp j ON e.mgr = j.empno)


