Feature: Expr
  In order to use Doctrine Query\Expr safely
  As a Psalm user
  I need Psalm to typecheck Expr

  Background:
    Given I have Doctrine plugin enabled
    And I have the following code preamble
      """
      <?php
      use Doctrine\ORM\QueryBuilder;
      use Doctrine\ORM\Query\Expr;

      /**
       * @psalm-suppress InvalidReturnType
       * @return QueryBuilder
       */
      function builder() {}
      """
    # Psalm enables cache when there's a composer.lock file
    And I have empty composer.lock

  @Expr
  Scenario: Expr::andX() accepts variadic arguments
    Given I have the following code
      """
      builder()->expr()->andX(
        'foo > bar',
        'foo < baz'
      );
      """
    When I run Psalm
    Then I see no errors

  @Expr
  Scenario: Expr::orX() accepts variadic arguments
    Given I have the following code
      """
      $expr = builder()->expr();
      $expr->orX(
        $expr->eq('foo', 1),
        $expr->eq('bar', 1)
      );
      """
    When I run Psalm
    Then I see no errors
