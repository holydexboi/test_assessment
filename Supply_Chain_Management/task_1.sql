
--- TOTAL QUANTITY OF PRODUCT SHIPPED BY EACH PRODUCT CATEGORY
SELECT pr."productCategory", SUM(sh.quantity) AS qty
FROM shipment sh
INNER JOIN product pr
ON sh."productId" = pr."productId"
GROUP BY pr."productCategory"
ORDER BY qty DESC

--- WAREHOUSE WITH THE MOST EFFICIENT SHIPPING PROCESS BASE ON AVERAGE SHIPPING TIME 
SELECT wr."warehouseName", AVG(sh."shippingDuration") AS avgDuration
FROM shipment sh
INNER JOIN warehouse wr
ON sh."warehouseId" = wr."warehouseId"
GROUP BY wr."warehouseName"
HAVING AVG(sh."shippingDuration") < (SELECT AVG("shippingDuration") FROM shipment)
ORDER BY AVG(sh."shippingDuration") DESC

--- TOTAL VALUE OF SHIPMENT FOR EACH SUPPLIER
SELECT sup."supplierName", SUM(s."shipmentValue") AS shipValue
FROM shipment s
INNER JOIN supplier sup
ON s."supplierId" = sup."supplierId"
GROUP BY sup."supplierName"
ORDER BY shipValue DESC

--- TOP 5 PRODUCTS WITH THE HEIGHEST QUANTITY OF SHIPMENT
SELECT pr."productName", SUM(sh.quantity) AS totalQuatity
FROM shipment sh
INNER JOIN product pr
ON sh."productId" = pr."productId"
GROUP BY pr."productName"
ORDER BY totalQuatity DESC
LIMIT 5

--- REPORT OF TOTAL VALUE OF SHIPMENT FOR EACH PRODUCT CATEGORY
SELECT pr."productCategory", SUM(sh."shipmentValue") AS totalValue
FROM shipment sh
INNER JOIN product pr
ON sh."productId" = pr."productId"
GROUP BY pr."productCategory"


