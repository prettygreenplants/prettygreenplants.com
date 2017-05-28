<?php
namespace PrettyGreenPlants\Shop\Domain\Model;

/*
 * This file is part of the PrettyGreenPlants.Shop package.
 */

use Neos\Flow\Annotations as Flow;
use Doctrine\ORM\Mapping as ORM;

/**
 * @Flow\Entity
 */
class Category
{

    /**
     * @var string
     */
    protected $name;

    /**
     * @var string
     */
    protected $description;

    /**
     * @var \PrettyGreenPlants\Shop\Domain\Model\Category
     * @ORM\ManyToOne
     */
    protected $parentCategory;


    /**
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param string $name
     * @return void
     */
    public function setName($name)
    {
        $this->name = $name;
    }

    /**
     * @return string
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * @param string $description
     * @return void
     */
    public function setDescription($description)
    {
        $this->description = $description;
    }

    /**
     * @return \PrettyGreenPlants\Shop\Domain\Model\Category
     */
    public function getParentCategory()
    {
        // TODO: If it is already the parentCategory, should return boolean for easier check in controller
        // Return type should be boolean also
        return $this->parentCategory;
    }

    /**
     * @param \PrettyGreenPlants\Shop\Domain\Model\Category $parentCategory
     * @return void
     */
    public function setParentCategory($parentCategory)
    {
        // TODO: Check if this category already has sub category, block them from being a sub cat because we don't support 3rd level cat
        $this->parentCategory = $parentCategory;
    }

}
