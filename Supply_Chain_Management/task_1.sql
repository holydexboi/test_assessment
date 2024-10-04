
--- TOTAL QUANTITY OF PRODUCT SHIPPED BY EACH PRODUCT CATEGORY

SELECT p."productCategory", SUM(s.quantity) as total_quantity_shipped
FROM shipment s
JOIN product p ON s."productId" = p."productId"
GROUP BY p."productCategory";
