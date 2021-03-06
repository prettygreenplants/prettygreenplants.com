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
class Product
{

    /**
     * @var string
     */
    protected $name;

    /**
     * @var \PrettyGreenPlants\Shop\Domain\Model\Category
     * @ORM\ManyToOne
     */
    protected $category;

    /**
     * @var string
     */
    protected $code;

    /**
     * @var integer
     */
    protected $cost;

    /**
     * @var string
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
     * @return \PrettyGreenPlants\Shop\Domain\Model\Category
     */
    public function getCategory()
    {
        return $this->category;
    }

    /**
     * @param \PrettyGreenPlants\Shop\Domain\Model\Category $category
     * @return void
     */
    public function setCategory($category)
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
