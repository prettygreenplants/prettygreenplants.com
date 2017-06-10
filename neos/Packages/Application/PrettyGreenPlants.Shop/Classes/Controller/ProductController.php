<?php

namespace PrettyGreenPlants\Shop\Controller;

/*
 * This file is part of the PrettyGreenPlants.Shop package.
 */
use Neos\Flow\Annotations as Flow;
use Neos\Flow\Mvc\Controller\ActionController;
use PrettyGreenPlants\Shop\Domain\Model\Product;
use PrettyGreenPlants\Shop\Domain\Repository\CategoryRepository;
use PrettyGreenPlants\Shop\Domain\Repository\ProductRepository;

class ProductController extends ActionController
{
    /**
     * @Flow\Inject
     * @var ProductRepository
     */
    protected $productRepository;

    /**
     * @Flow\Inject
     * @var CategoryRepository
     */
    protected $categoryRepository;

    /**
     * @return void
     */
    public function indexAction()
    {
        $this->view->assign('products', $this->productRepository->findAll());
    }

    /**
     * @param Product $product
     *
     * @return void
     */
    public function showAction(Product $product)
    {
        $this->view->assign('product', $product);
    }

    /**
     * @return void
     */
    public function newAction()
    {
        $this->view->assign('categories', $this->categoryRepository->findAll());
    }

    /**
     * @param Product $newProduct
     *
     * @return void
     */
    public function createAction(Product $newProduct)
    {
        $this->productRepository->add($newProduct);
        $this->addFlashMessage('Created a new product.');
        $this->redirect('index');
    }

    /**
     * @param Product $product
     *
     * @return void
     */
    public function editAction(Product $product)
    {
        $this->view->assign('product', $product);
        $this->view->assign('categories', $this->categoryRepository->findAll());
    }

    /**
     * @param Product $product
     *
     * @return void
     */
    public function updateAction(Product $product)
    {
        $this->productRepository->update($product);
        $this->addFlashMessage('Updated the product.');
        $this->redirect('index');
    }

    /**
     * @param Product $product
     *
     * @return void
     */
    public function deleteAction(Product $product)
    {
        $this->productRepository->remove($product);
        $this->addFlashMessage('Deleted a product.');
        $this->redirect('index');
    }
}
