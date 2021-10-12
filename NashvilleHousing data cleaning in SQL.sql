Select *
from Portfolio_project.dbo.NashvilleHousing

Select SaleDate , convert(Date,SaleDate)
from Portfolio_project.dbo.NashvilleHousing

Update NashvilleHousing 
set SaleDate = convert(Date,SaleDate)

--Converting SaleDate to Date type

alter table NashvilleHousing
add SaleDateConverted date;

Update NashvilleHousing 
set SaleDateConverted = convert(Date,SaleDate)

Select SaleDateConverted 
from Portfolio_project.dbo.NashvilleHousing

----------------Filling NULL value in property address with reference from parcel id-----------------------------------------

Select *
from Portfolio_project.dbo.NashvilleHousing
where PropertyAddress is null 

Select *
from Portfolio_project.dbo.NashvilleHousing
order by ParcelID;

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
From Portfolio_project.dbo.NashvilleHousing a
join Portfolio_project.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null
 
 Update a
 set a.PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 From Portfolio_project.dbo.NashvilleHousing a
join Portfolio_project.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


Select * From Portfolio_project.dbo.NashvilleHousing

-- Splitting PropertyAddress
Select PropertyAddress From Portfolio_project.dbo.NashvilleHousing

select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
From Portfolio_project.dbo.NashvilleHousing


Alter table NashvilleHousing 
Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table NashvilleHousing 
Add PropertyCity Nvarchar(255)

Update NashvilleHousing
set PropertyCity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

-- Parsing Owner Address--
Select OwnerAddress from  Portfolio_project.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From Portfolio_project.dbo.NashvilleHousing

Alter table NashvilleHousing 
Add OwnersplitAddress Nvarchar(255)

Update NashvilleHousing
set OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table NashvilleHousing 
Add OwnerCity Nvarchar(255)

Update NashvilleHousing
set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table NashvilleHousing 
Add OwnerState Nvarchar(255)

Update NashvilleHousing
set OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select * from  Portfolio_project.dbo.NashvilleHousing

---- Change Y and N from'Soldasvacant' to Yes and No ----

Select distinct(SoldAsVacant),Count(SoldAsVacant) from  Portfolio_project.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from  Portfolio_project.dbo.NashvilleHousing

Update NashvilleHousing 
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end

----- Remove Columns -----
Select *
From Portfolio_project.dbo.NashvilleHousing


ALTER TABLE Portfolio_project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
