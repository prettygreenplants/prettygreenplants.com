<?php

namespace PrettyGreenPlants\Shop\Domain\Repository;

/*
 * This file is part of the PrettyGreenPlants.Shop package.
 */
use Neos\Flow\Annotations as Flow;
use Neos\Flow\Persistence\Repository;
use PrettyGreenPlants\Shop\Domain\Model\Category;

/**
 * @Flow\Scope("singleton")
 */
class CategoryRepository extends Repository
{

    /**
     * @param Category $category
     *
     * @return QueryResultInterface
     */
    public function findPossibleParentCategories(Category $category)
    {
        $query = $this->createQuery();

        $result = $query->matching(
            $query->logicalAnd(
                $query->equals('parentCategory', null),
                $query->logicalNot(
                    $query->equals('name', $category->getName())
                )
            )
        );

        return $result->execute();
    }
}
