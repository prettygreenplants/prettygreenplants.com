<?php

namespace PrettyGreenPlants\Shop\Domain\Model;

/*
 * This file is part of the PrettyGreenPlants.Shop package.
 */
use Neos\Flow\Annotations as Flow;
use Doctrine\ORM\Mapping as ORM;
use Neos\Flow\Mvc\Exception\UnsupportedRequestTypeException;
use Neos\Flow\Persistence\PersistenceManagerInterface;
use Neos\Flow\Persistence\QueryResultInterface;
use PrettyGreenPlants\Shop\Domain\Repository\CategoryRepository;

/**
 * @Flow\Entity
 */
class Category
{
    /**
     * @var string
     * @Flow\Validate(type="NotEmpty")
     */
    protected $name;

    /**
     * @var string
     * @ORM\Column(type="string", nullable=true)
     */
    protected $description;

    /**
     * @var Category
     * @ORM\ManyToOne
     */
    protected $parentCategory;

    /**
     * @var CategoryRepository
     * @Flow\Inject
     */
    protected $categoryRepository;

    /**
     * @var PersistenceManagerInterface
     * @Flow\Inject
     */
    protected $persistenceManager;

    /**
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param string $name
     *
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
     *
     * @return void
     */
    public function setDescription($description)
    {
        $this->description = $description;
    }

    /**
     * @return bool
     */
    public function isTopLevelCategory()
    {
        if ($this->getParentCategory() === null) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @return Category
     */
    public function getParentCategory()
    {
        return $this->parentCategory;
    }

    /**
     * @param Category $category
     *
     * @return void
     * @throws UnsupportedRequestTypeException
     */
    public function setParentCategory($category)
    {
        if (($category instanceof Category) && (! $category->isTopLevelCategory() || $this->isParent())) {
            throw new UnsupportedRequestTypeException('Only one level sub-category is allowed!', 1497099382);
        }

        $this->parentCategory = $category;
    }

    /**
     * @return bool
     */
    public function isParent()
    {
        $objectIdentifier = $this->persistenceManager->getIdentifierByObject($this);
        if ($this->categoryRepository->countByParentCategory($objectIdentifier) > 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @return QueryResultInterface|null
     */
    public function getChildren()
    {
        if ($this->isParent()) {
            $objectIdentifier = $this->persistenceManager->getIdentifierByObject($this);

            return $this->categoryRepository->findByParentCategory($objectIdentifier);
        } else {
            return null;
        }
    }
}
