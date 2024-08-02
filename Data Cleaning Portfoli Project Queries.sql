--cleaning Data in Sql Queries


Select *
From PortfolioProject..NashvilleHousing




--standardize Date Format
Select SaleDateConverted , CONVERT (Date , SaleDate)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted Date ;

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date , SaleDate)





--Popular Property ADDress date

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is  NULL
Order by ParcelID

Select a.ParcelID ,a.PropertyAddress , b.ParcelID ,b.PropertyAddress ,ISNULL(a.PropertyAddress ,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is NULL 

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress ,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is NULL 




--Breaking out Address into Individual Columns (Address , City , State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is  NULL
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress , 1 , CHARINDEX(',' ,PropertyAddress )-1) as Address,
SUBSTRING(PropertyAddress ,  CHARINDEX(',' ,PropertyAddress )+1 , LEN(PropertyAddress )) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255) ;

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress , 1 , CHARINDEX(',' ,PropertyAddress )-1) 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255) ;

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress ,  CHARINDEX(',' ,PropertyAddress )+1 , LEN(PropertyAddress )) 

Select *
From PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing 

Select
PARSENAME(REPLACE(OwnerAddress , ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress , ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress , ',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing 


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255) ;

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress , ',', '.'), 3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255) ;

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress , ',', '.'), 2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255) ;

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress , ',', '.'), 1)

Select*
From PortfolioProject.dbo.NashvilleHousing 





--Change Y and N to Yes and No in 'Sold as Vacant' field

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing 
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End
From PortfolioProject.dbo.NashvilleHousing 

Update PortfolioProject.dbo.NashvilleHousing 
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End





--Remove Duplicates


With RowNumCTE AS (
Select * ,
	ROW_NUMBER() OVER  (
	PARTITION BY  ParcelID,
				  PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  Order BY 
					UniqueID
						) row_num
From PortfolioProject.dbo.NashvilleHousing 

--order by ParcelID
)
--DELETE
--From RowNumCTE
--Where row_num > 1
----order by PropertyAddress

Select *
From RowNumCTE
Where row_num > 1
order by PropertyAddress







--Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
DROP COLUMN OwnerAddress , TaxDistrict ,PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
DROP COLUMN SaleDate

