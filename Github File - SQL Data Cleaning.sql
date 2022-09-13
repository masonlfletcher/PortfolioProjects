Create Database PortfolioProjectNashvilleHousing

Select * 
from PortfolioProjectNashvilleHousing..NashvilleHousing



 --Cleaning Data with SQL Queries
 -------------------------------------------------------------------------------------------------------------------------------
  -- Standardizing Date Format
  select SaleDateConverted, Convert(Date,SaleDate)
  from PortfolioProjectNashvilleHousing..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)






----------------------------------------------------------------------------------------------------------------------------------
 -- Populate Property Address data

 Select * 
 from PortfolioProjectNashvilleHousing..NashvilleHousing
 -- where PropertyAddress is NULL 
 order by ParcelID



 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
 from PortfolioProjectNashvilleHousing..NashvilleHousing as a
 JOIN PortfolioProjectNashvilleHousing..NashvilleHousing as b
		on a.ParcelID = b.ParcelID
		and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 from PortfolioProjectNashvilleHousing..NashvilleHousing a
 JOIN PortfolioProjectNashvilleHousing..NashvilleHousing b
		on a.ParcelID = b.ParcelID
		and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL

-- Verifying Update Took Effect
 Select * 
 from PortfolioProjectNashvilleHousing..NashvilleHousing
  where PropertyAddress is NULL 
 order by ParcelID

-- Verifying Update Took Effect by checking FULL datatable
 Select * 
 from PortfolioProjectNashvilleHousing..NashvilleHousing
 order by ParcelID







---------------------------------------------------------------------------------------------------------------------------------------
 -- Breaking out Address into Individual Columns (Address, City, State)

 Select PropertyAddress
 from PortfolioProjectNashvilleHousing..NashvilleHousing


 Select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
 from PortfolioProjectNashvilleHousing..NashvilleHousing


 Select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
 CHARINDEX(',', PropertyAddress)
 from PortfolioProjectNashvilleHousing..NashvilleHousing


  Select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
 from PortfolioProjectNashvilleHousing..NashvilleHousing

 ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitAddressCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select *
 from PortfolioProjectNashvilleHousing..NashvilleHousing


 Select OwnerAddress
 from PortfolioProjectNashvilleHousing..NashvilleHousing

 --Using PARSENAME instead of SUBSTRING to change OwnerAddress
 Select
 PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
 from PortfolioProjectNashvilleHousing..NashvilleHousing


 ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)



 ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select *
from PortfolioProjectNashvilleHousing..NashvilleHousing






 ---------------------------------------------------------------------------------------------------------------------------------------
 -- Change Y and N to Yes and No in "Sold as Vacant" field

 Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
 from PortfolioProjectNashvilleHousing..NashvilleHousing
 group by SoldAsVacant
 order by 2


 Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
from PortfolioProjectNashvilleHousing..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END






----------------------------------------------------------------------------------------------------------------------------------------
 -- Remove Duplicates

 --CTE
 WITH RowNumCTE AS(
 Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num		
 from PortfolioProjectNashvilleHousing..NashvilleHousing
)
select *
from RowNumCTE
Where row_num > 1




 
 ---------------------------------------------------------------------------------------------------------------------------------------
 -- Delete Unused Columns

 Select *
 from PortfolioProjectNashvilleHousing..NashvilleHousing

 ALTER TABLE PortfolioProjectNashvilleHousing..NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

  ALTER TABLE PortfolioProjectNashvilleHousing..NashvilleHousing
 DROP COLUMN SaleDate


