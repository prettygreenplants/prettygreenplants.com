<?php
namespace PrettyGreenPlants\Shop\Domain\Model;

/*
 * This file is part of the PrettyGreenPlants.Shop package.
 */

use Neos\Flow\Annotations as Flow;
use Doctrine\ORM\Mapping as ORM;
use PrettyGreenPlants\Shop\Domain\Model\Category;

/**
 * @Flow\Entity
 */
class Product
{

    /**
     * @var string
     * @Flow\Validate(type="NotEmpty")
     */
    protected $name;

    /**
     * @var Category
     * @ORM\ManyToOne
     * @Flow\Validate(type="NotEmpty")
     */
    protected $category;

    /**
     * @var string
     * @Flow\Validate(type="NotEmpty")
     */
    protected $code;

    /**
     * @var integer
     * @Flow\Validate(type="NotEmpty")
     */
    protected $cost;

    /**
     * @var string
     * @ORM\Column(type="string", nullable=true)
     */
    protected $description;


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
     * @return Category
     */
    public function getCategory()
    {
        return $this->category;
    }

    /**
     * @param Category $category
     * @return void
     */
    public function setCategory(Category $category)
    {
        $this->category = $category;
    }

    /**
     * @return string
     */
    public function getCode()
    {
        return $this->code;
    }

    /**
     * @param string $code
     * @return void
     */
    public function setCode($code)
    {
        $this->code = $code;
    }

    /**
     * @return integer
     */
    public function getCost()
    {
        return $this->cost;
    }

    /**
     * @param integer $cost
     * @return void
     */
    public function setCost($cost)
    {
        $this->cost = $cost;
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

}
