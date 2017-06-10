<?php

namespace PrettyGreenPlants\Shop\Controller;

/*
 * This file is part of the PrettyGreenPlants.Shop package.
 */
use Neos\Flow\Annotations as Flow;
use Neos\Flow\Mvc\Controller\ActionController;
use PrettyGreenPlants\Shop\Domain\Repository\CategoryRepository;
use PrettyGreenPlants\Shop\Domain\Repository\ProductRepository;

class StandardController extends ActionController
{
    /**
     * @var CategoryRepository
     * @Flow\Inject
     */
    protected $categoryRepository;

    /**
     * @var ProductRepository
     * @Flow\Inject
     */
    protected $productRepository;

    /**
     * @return void
     */
    public function indexAction()
    {
        $this->view->assign(
            'topLevelCategories',
            $this->categoryRepository->findByParentCategory(null)
        );
        $this->view->assign('products', $this->productRepository->findAll());
    }
}
