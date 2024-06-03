

--100--

--1--
SELECT p.pname, d.dname
FROM pro p JOIN dept d ON p.deptno = d.DEPTNO


--2--
SELECT ename, prono
FROM emppro ep JOIN emp e ON ep.empno = e.empno

--3--
SELECT ename, prono
FROM emppro ep RIGHT JOIN emp e ON ep.empno = e.empno

--4--
SELECT e1.ename, e2.ename
FROM emp e1 left JOIN emp e2 ON e1.mgr = e2.empno 

--5--
SELECT e1.ename, e2.ename, dname
FROM emp e1 left JOIN emp e2 ON e1.mgr = e2.empno 
	JOIN dept d ON e2.deptno = d.deptno

--6--
SELECT e1.ename, e1.sal, e2.ename, e2.sal
FROM emp e1 JOIN emp e2 ON e1.mgr = e2.EMPNO 
WHERE e1.sal > e2.sal



--102--

--1--
SELECT ename, sum(hours)
FROM emp e JOIN emppro ep ON e.empno = ep.EMPNO 
GROUP BY ename, e.empno

--2--
SELECT dname, count(empno)
FROM emp e JOIN dept d ON e.deptno = d.DEPTNO
GROUP BY DNAME

--3--
SELECT e2.ename, COUNT(*)
FROM emp e1 LEFT JOIN emp e2 ON e1.mgr = e2.EMPNO
GROUP BY e2.ename

--4--
SELECT pname, sum(hours)
FROM emppro ep JOIN pro p ON ep.prono = p.PRONO 
GROUP BY pname

--5--
SELECT dname, count(*)
FROM dept d JOIN pro p ON d.DEPTNO = p.DEPTNO 
GROUP BY DNAME 
HAVING count (*) > 2

--6--
SELECT dname
FROM dept d JOIN emp e ON d.DEPTNO = e.DEPTNO 
GROUP BY DNAME 
HAVING count (*) >= 2

--7--
SELECT d.dname, COALESCE (count(e.empno), 0) empleados
FROM emp e right JOIN dept d ON e.deptno = d.DEPTNO
GROUP BY d.DNAME

--8--
SELECT e.empno, COALESCE (sum(ep.hours), 0) horas
FROM emp e LEFT JOIN emppro ep ON e.empno=ep.EMPNO
GROUP BY e.EMPNO 

--9--
SELECT e2.empno, COALESCE (count(*), 0)
FROM emp e1 JOIN emp e2 ON e1.mgr = e2.EMPNO
WHERE e1.sal > e2.sal
GROUP BY e2.EMPNO



--110--

--1--
SELECT ename
FROM emp
WHERE sal > (SELECT avg(sal) FROM emp)

--2--
SELECT dname, count (*)
FROM dept d JOIN emp e ON d.deptno = e.DEPTNO
WHERE sal > (SELECT avg(sal) FROM emp)
GROUP BY dname

--3--
SELECT DISTINCT j.ename
FROM emp e JOIN emp j ON e.mgr = j.empno

--4--
SELECT ename 
FROM emp 
WHERE empno NOT IN (SELECT mgr FROM emp
					WHERE mgr IS NOT null)

--5--
SELECT ename
FROM emp 
WHERE sal = (SELECT max(sal) FROM emp)

--6--
SELECT dname
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY dname
having sum(sal) IN (SELECT max(sum(sal)) FROM emp 
					GROUP BY deptno)

--7--
SELECT dname, count(comm), count(*) - count(comm)
FROM emp e JOIN dept d ON e.deptno = d.DEPTNO 
WHERE d.deptno IN (SELECT deptno FROM EMP
					WHERE comm IS NOT null)
GROUP BY DNAME 



--120--

--1--
SELECT deptno, ename, sal
FROM emp e 
WHERE sal = (SELECT max(sal) FROM EMP
			WHERE deptno = e.deptno)

--2--
SELECT prono, empno, hours
FROM emppro ep
WHERE hours = (SELECT max(hours) FROM emppro
				WHERE prono = ep.prono)

--3--
SELECT prono, ename, hours
FROM emppro ep JOIN emp e ON ep.empno = e.EMPNO 
WHERE hours = (SELECT max(hours) FROM emppro
				WHERE prono = ep.prono)

--4--
SELECT p.prono, pname, ename, hours
FROM emppro ep JOIN emp e ON ep.empno = e.EMPNO
	JOIN pro p ON ep.prono = p.prono
WHERE hours = (SELECT max(hours) FROM emppro
				WHERE prono = ep.prono)

--5--
SELECT dname, count(*)
FROM emp e JOIN dept d ON e.deptno = d.DEPTNO 
WHERE sal >= (SELECT avg(sal) FROM EMP
				WHERE deptno = e.deptno)
GROUP BY dname

--6--
SELECT dname, count (*)
FROM emp e JOIN dept d ON e.deptno = d.DEPTNO 
WHERE sal >= (SELECT sal FROM EMP
				WHERE deptno = e.deptno AND empno=e.mgr)
GROUP BY dname




