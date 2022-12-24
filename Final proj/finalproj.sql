USE final_project;
SET sql_mode = (SELECT REPLACE(@@SQL_MODE, "ONLY_FULL_GROUP_BY", ""));

CREATE OR REPLACE VIEW finaldw AS
SELECT cu.CustomerId, cu.FirstName, cu.LastName, cu.Country, MIN(inv.InvoiceDate) as ear_invoice_date, MAX(inv.InvoiceDate) as recent_invoice_date, SUM(DISTINCT inv.Total) as Total,
	COUNT(DISTINCT trk.TrackId) as num_of_track, COUNT(DISTINCT trk.MediaTypeId) as Media_Tried_Num, COUNT(DISTINCT trk.GenreId) as Genre_Tried_Num, gmode.GenreId as Favorite_Genre_Id,gmode.Name as Favorite_Genre, mmode.MediaTypeId as Favorite_Media_Id,  mmode.Name as Favorite_Media, amode.ArtistId as Favorite_Artist_Id, amode.Name as Favorite_Artist
FROM customer cu
JOIN (SELECT i.InvoiceId, i.CustomerID,i.InvoiceDate,i.Total
	FROM invoice i) AS inv
	ON cu.CustomerId = inv.CustomerId
JOIN (SELECT Quantity, iline.TrackID,iline.InvoiceId
	FROM invoiceline iline) AS invline
    ON invline.InvoiceId = inv.InvoiceId
JOIN (SELECT tr.MediaTypeId, tr.GenreId, tr.TrackId, tr.AlbumId
	FROM track tr) as trk
    ON trk.TrackId = invline.TrackId
JOIN (SELECT m.MediaTypeId, m.Name AS mediatype_name
	FROM mediatype m) as me
    ON me.MediaTypeId = trk.MediaTypeId
JOIN (SELECT g.GenreId, g.Name AS genre_name
	FROM genre g) as ge
	ON ge.GenreId = trk.GenreId
JOIN (SELECT a.AlbumId, a.ArtistId
	FROM album a) as al
	ON al.AlbumId = trk.AlbumId
JOIN (SELECT ar.ArtistId, ar.Name AS artist_name
	FROM artist ar) as art
	ON art.ArtistId = al.ArtistId
JOIN (SELECT m1.*
		FROM 
			(SELECT cu.CustomerId, trk.GenreId, COUNT(Quantity) as GenreEnum, ge.name
			FROM customer cu
			JOIN (SELECT InvoiceId, i.CustomerID, i.InvoiceDate, i.Total
				FROM invoice i) AS inv
				ON cu.CustomerId = inv.CustomerId
			JOIN invoiceline AS invline
				ON invline.InvoiceId = inv.InvoiceId
			JOIN track as trk ON trk.TrackId = invline.TrackId
			JOIN mediatype as me ON me.MediaTypeId = trk.MediaTypeId
			JOIN genre as ge ON ge.GenreId = trk.GenreId
			JOIN album as al ON al.AlbumId = trk.AlbumId
			JOIN artist as art ON art.ArtistId = al.ArtistId
			GROUP BY CustomerId, GenreId) m1 LEFT JOIN 
            (SELECT cu.CustomerId, trk.GenreId, COUNT(Quantity) as GenreEnum, ge.name
			FROM customer cu
			JOIN (SELECT InvoiceId, i.CustomerID, i.InvoiceDate, i.Total
				FROM invoice i) AS inv
				ON cu.CustomerId = inv.CustomerId
			JOIN invoiceline AS invline
				ON invline.InvoiceId = inv.InvoiceId
			JOIN track as trk ON trk.TrackId = invline.TrackId
			JOIN mediatype as me ON me.MediaTypeId = trk.MediaTypeId
			JOIN genre as ge ON ge.GenreId = trk.GenreId
			JOIN album as al ON al.AlbumId = trk.AlbumId
			JOIN artist as art ON art.ArtistId = al.ArtistId
			GROUP BY CustomerId, GenreId) m2
        ON (m1.CustomerId = m2.CustomerId AND m1.GenreEnum < m2.GenreEnum)
		WHERE m2.GenreEnum IS NULL)as gmode
    ON gmode.CustomerId = cu.CustomerId
JOIN (SELECT m3.*
		FROM (
			SELECT cu.CustomerId, trk.MediaTypeId, COUNT(Quantity) as MediaEnum, me.name
			FROM customer cu
			JOIN (SELECT InvoiceId, i.CustomerID, i.InvoiceDate, i.Total
				FROM invoice i) AS inv
				ON cu.CustomerId = inv.CustomerId
			JOIN invoiceline invline
				ON invline.InvoiceId = inv.InvoiceId
			JOIN track as trk ON trk.TrackId = invline.TrackId
			JOIN mediatype as me ON me.MediaTypeId = trk.MediaTypeId
			JOIN genre as ge ON ge.GenreId = trk.GenreId
			JOIN album as al ON al.AlbumId = trk.AlbumId
			JOIN artist as art ON art.ArtistId = al.ArtistId
			GROUP BY CustomerId, MediaTypeId)m3 LEFT JOIN 
            (
			SELECT cu.CustomerId, trk.MediaTypeId, COUNT(Quantity) as MediaEnum,me.name
			FROM customer cu
			JOIN (SELECT InvoiceId, i.CustomerID, i.InvoiceDate, i.Total
				FROM invoice i) AS inv
				ON cu.CustomerId = inv.CustomerId
			JOIN invoiceline invline
				ON invline.InvoiceId = inv.InvoiceId
			JOIN track as trk ON trk.TrackId = invline.TrackId
			JOIN mediatype as me ON me.MediaTypeId = trk.MediaTypeId
			JOIN genre as ge ON ge.GenreId = trk.GenreId
			JOIN album as al ON al.AlbumId = trk.AlbumId
			JOIN artist as art ON art.ArtistId = al.ArtistId
			GROUP BY CustomerId, MediaTypeId) m4
        ON (m3.CustomerId = m4.CustomerId AND m3.MediaEnum < m4.MediaEnum)
		WHERE m4.MediaEnum IS NULL)as mmode
    ON mmode.CustomerId = cu.CustomerId
JOIN (SELECT m5.*
		FROM (
			SELECT cu.CustomerId, art.ArtistId,trk.AlbumId, COUNT(Quantity) as ArtEnum, art.name
			FROM customer cu
			JOIN (SELECT InvoiceId, i.CustomerID, i.InvoiceDate, i.Total
				FROM invoice i) AS inv
				ON cu.CustomerId = inv.CustomerId
			JOIN invoiceline invline
				ON invline.InvoiceId = inv.InvoiceId
			JOIN track as trk ON trk.TrackId = invline.TrackId
			JOIN mediatype as me ON me.MediaTypeId = trk.MediaTypeId
			JOIN genre as ge ON ge.GenreId = trk.GenreId
			JOIN album as al ON al.AlbumId = trk.AlbumId
			JOIN artist as art ON art.ArtistId = al.ArtistId
			GROUP BY CustomerId, ArtistId)m5 LEFT JOIN 
            (
			SELECT cu.CustomerId, trk.AlbumId, art.ArtistId, COUNT(Quantity) as ArtEnum, art.name
			FROM customer cu
			JOIN (SELECT InvoiceId, i.CustomerID, i.InvoiceDate, i.Total
				FROM invoice i) AS inv
				ON cu.CustomerId = inv.CustomerId
			JOIN invoiceline invline
				ON invline.InvoiceId = inv.InvoiceId
			JOIN track as trk ON trk.TrackId = invline.TrackId
			JOIN mediatype as me ON me.MediaTypeId = trk.MediaTypeId
			JOIN genre as ge ON ge.GenreId = trk.GenreId
			JOIN album as al ON al.AlbumId = trk.AlbumId
			JOIN artist as art ON art.ArtistId = al.ArtistId
			GROUP BY CustomerId, ArtistId) m6
        ON (m5.CustomerId = m6.CustomerId AND m5.ArtEnum < m6.ArtEnum)
		WHERE m6.ArtEnum IS NULL)as amode
    ON amode.CustomerId = cu.CustomerId

GROUP BY CustomerId
ORDER BY CustomerId
;


