<?php
namespace PrettyGreenPlants\Shop\Controller;

/*
 * This file is part of the PrettyGreenPlants.Shop package.
 */

use Neos\Flow\Annotations as Flow;
use Neos\Flow\Mvc\Controller\ActionController;
use PrettyGreenPlants\Shop\Domain\Model\Category;
use PrettyGreenPlants\Shop\Domain\Repository\CategoryRepository;

class CategoryController extends ActionController
{

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
        $this->view->assign(
            'categories',
            $this->categoryRepository->findByParentCategory(null)
        );
    }

    /**
     * @param Category $category
     * @return void
     */
    public function showAction(Category $category)
    {
        $this->view->assign('category', $category);
    }

    /**
     * @return void
     */
    public function newAction()
    {
        $this->view->assign('parentCategories', $this->categoryRepository->findByParentCategory(null));
    }

    /**
     * @param Category $newCategory
     * @return void
     */
    public function createAction(Category $newCategory)
    {
        $this->categoryRepository->add($newCategory);
        $this->addFlashMessage('Created a new category.');
        $this->redirect('index');
    }

    /**
     * @param Category $category
     * @return void
     */
    public function editAction(Category $category)
    {
        $this->view->assign('category', $category);
        $this->view->assign('parentCategories', $this->categoryRepository->findPossibleParentCategories($category));
    }

    /**
     * @param Category $category
     * @return void
     */
    public function updateAction(Category $category)
    {
        $this->categoryRepository->update($category);
        $this->addFlashMessage('Updated the category.');
        $this->redirect('index');
    }

    /**
     * @param Category $category
     * @return void
     */
    public function deleteAction(Category $category)
    {
        $this->categoryRepository->remove($category);
        $this->addFlashMessage('Deleted a category.');
        $this->redirect('index');
    }

}
