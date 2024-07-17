-- 1
SELECT DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;

-- 2
SELECT Posts.Title, Users.DisplayName
FROM Posts
JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL;

-- 3
SELECT Users.DisplayName, AVG(Posts.Score) AS AverageScore
FROM Posts
JOIN Users ON Posts.OwnerUserId = Users.Id
GROUP BY Users.DisplayName;

-- 4
SELECT u.DisplayName
FROM Users u
WHERE (SELECT COUNT(*) FROM Comments c WHERE c.UserId = u.Id) > 100;

-- 5
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

PRINT 'Se actualiz� correctamente, las Ubicaciones vacias se han cambiado a "Desconocido"';

-- 6
DELETE FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);
DECLARE @RowsAffected INT;
SET @RowsAffected = @@ROWCOUNT;

PRINT 'Fueron eliminados '  + CAST(@RowsAffected AS VARCHAR(10)) + ' comentarios de los usuarios con menos de 100 de reputacion';

-- 7
SELECT TOP 200
    Users.DisplayName,
    COALESCE(p.TotalPosts, 0) AS TotalPosts,
    COALESCE(c.TotalComments, 0) AS TotalComments,
    COALESCE(b.TotalBadges, 0) AS TotalBadges
FROM 
    Users 
LEFT JOIN 
    (SELECT OwnerUserId, COUNT(*) AS TotalPosts 
    FROM Posts 
    GROUP BY OwnerUserId) p
    ON Users.Id = p.OwnerUserId
LEFT JOIN 
    (SELECT UserId, COUNT(*) AS TotalComments 
    FROM Comments 
    GROUP BY UserId) c
    ON Users.Id = c.UserId
LEFT JOIN 
    (SELECT UserId, COUNT(*) AS TotalBadges 
    FROM Badges 
    GROUP BY UserId) b
    ON Users.Id = b.UserId;

-- 8
SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;

-- 9
SELECT TOP 5 Text, CreationDate
FROM  Comments
ORDER BY CreationDate DESC;