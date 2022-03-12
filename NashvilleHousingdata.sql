SELECT * FROM Nashville_Housing_Data_for_Data_Cleaning_csv a 

-- Populate Property Address data

SELECT * 
from Nashville_Housing_Data_for_Data_Cleaning_csv a 
-- where PropertyAddress is ''
order by ParcelID 
 


SELECT a.ParcelID, a.PropertyAddress , b.ParcelID , b.PropertyAddress, COALESCE(NULLIF(a.PropertyAddress,''), b.PropertyAddress)
from Nashville_Housing_Data_for_Data_Cleaning_csv a
JOIN Nashville_Housing_Data_for_Data_Cleaning_csv b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress is ''




Update a
SET PropertyAddress = COALESCE(NULLIF(a.PropertyAddress,''), b.PropertyAddress)
FROM Nashville_Housing_Data_for_Data_Cleaning_csv a
JOIN Nashville_Housing_Data_for_Data_Cleaning_csv b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress is ''
 

-- Breaking out Property Address into Individual Columns (Address, City, )


SELECT PropertyAddress 
from Nashville_Housing_Data_for_Data_Cleaning_csv a 
-- where PropertyAddress is ''
-- order by ParcelID 


SELECT 
	substr (PropertyAddress, 1, instr (PropertyAddress, ',') - 1) AS address_split,
	substr (PropertyAddress, instr(PropertyAddress, ',') + 1) AS city_split 
FROM Nashville_Housing_Data_for_Data_Cleaning_csv  



ALTER table Nashville_Housing_Data_for_Data_Cleaning_csv 
Add PropertySplitAddress nvarchar(255);

UPDATE Nashville_Housing_Data_for_Data_Cleaning_csv 
SET PropertySplitAddress = substr (PropertyAddress, 1, instr (PropertyAddress, ',') - 1)


ALTER table Nashville_Housing_Data_for_Data_Cleaning_csv 
Add PropertySplitCity nvarchar(255);

UPDATE Nashville_Housing_Data_for_Data_Cleaning_csv
SET propertySplitcity = substr (PropertyAddress, instr(PropertyAddress, ',') + 1)



-- Breaking out Owner Address into Individual Columns (Address, City, State)

SELECT 
	substr (OwnerAddress, 1, instr (OwnerAddress, ',') - 1) AS owner_address_split,
	substr (OwnerAddress, instr(OwnerAddress, ',') + 1 ) AS owner_city_split
	
	
FROM Nashville_Housing_Data_for_Data_Cleaning_csv  


alter table Nashville_Housing_Data_for_Data_Cleaning_csv 
add owner_address_split nvarchar(255); 

UPDATE Nashville_Housing_Data_for_Data_Cleaning_csv 
SET owner_address_split = substr (OwnerAddress, 1, instr (OwnerAddress, ',') - 1)

alter table Nashville_Housing_Data_for_Data_Cleaning_csv 
add owner_city_split nvarchar(255); 

UPDATE Nashville_Housing_Data_for_Data_Cleaning_csv 
set owner_city_split = substr (OwnerAddress, instr(OwnerAddress, ',') + 1 )


 -- Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT (SoldAsVacant), COUNT(SoldAsVacant) 
from Nashville_Housing_Data_for_Data_Cleaning_csv nhdfdcc 
group by SoldAsVacant 
order by 2



SELECT SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant 
	 END
from Nashville_Housing_Data_for_Data_Cleaning_csv nhdfdcc 


update Nashville_Housing_Data_for_Data_Cleaning_csv 
set SoldAsVacant = 
Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant 
	 END


-- Remove Duplicates 

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER () Over (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference 
				 	) ROW_NUMBER 
FROM Nashville_Housing_Data_for_Data_Cleaning_csv nhdfdcc 
-- order by ParcelID 
)
DELETE 
From RowNumCTE 
Where ROW_NUMBER > 1 



-- Delete un-used columns

select * 
FROM Nashville_Housing_Data_for_Data_Cleaning_csv nhdfdcc 

Alter table Nashville_Housing_Data_for_Data_Cleaning_csv 
DROP COLUMN  taxdistrict

Alter table Nashville_Housing_Data_for_Data_Cleaning_csv 
DROP COLUMN  propertyaddress 

Alter table Nashville_Housing_Data_for_Data_Cleaning_csv 
DROP COLUMN  owneraddres





















