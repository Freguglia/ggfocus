library(testthat)
library(ggfocus)

test_that("scale_alpha_focus returns correct structure", {
  res <- scale_alpha_focus(focus_levels = "A", alpha_focus = 0.9, alpha_other = 0.1)
  expect_type(res, "list")
  expect_equal(res$focus_levels, "A")
  expect_equal(res$alpha_focus, 0.9)
  expect_equal(res$alpha_other, 0.1)
  expect_s3_class(res, "ggfocus_alpha")
})

test_that("scale_color_focus returns correct structure", {
  res <- scale_color_focus(focus_levels = c("A", "B"), color_focus = c("red", "blue"), color_other = "gray", palette_focus = "Set2")
  expect_type(res, "list")
  expect_equal(res$focus_levels, c("A", "B"))
  expect_equal(res$color_focus, c("red", "blue"))
  expect_equal(res$color_other, "gray")
  expect_equal(res$palette_focus, "Set2")
  expect_s3_class(res, "ggfocus_color")
})

test_that("scale_fill_focus returns correct structure", {
  res <- scale_fill_focus(focus_levels = "A", color_focus = "red", color_other = "gray", palette_focus = "Set1")
  expect_type(res, "list")
  expect_equal(res$focus_levels, "A")
  expect_equal(res$color_focus, "red")
  expect_equal(res$color_other, "gray")
  expect_equal(res$palette_focus, "Set1")
  expect_s3_class(res, "ggfocus_fill")
})

test_that("scale_linetype_focus returns correct structure", {
  res <- scale_linetype_focus(focus_levels = "A", linetype_focus = 2, linetype_other = 3)
  expect_type(res, "list")
  expect_equal(res$focus_levels, "A")
  expect_equal(res$linetype_focus, 2)
  expect_equal(res$linetype_other, 3)
  expect_s3_class(res, "ggfocus_linetype")
})

test_that("scale_shape_focus returns correct structure", {
  res <- scale_shape_focus(focus_levels = "A", shape_focus = 8, shape_other = 1)
  expect_type(res, "list")
  expect_equal(res$focus_levels, "A")
  expect_equal(res$shape_focus, 8)
  expect_equal(res$shape_other, 1)
  expect_s3_class(res, "ggfocus_shape")
})

test_that("scale_size_focus returns correct structure", {
  res <- scale_size_focus(focus_levels = "A", size_focus = 3, size_other = 1)
  expect_type(res, "list")
  expect_equal(res$focus_levels, "A")
  expect_equal(res$size_focus, 3)
  expect_equal(res$size_other, 1)
  expect_s3_class(res, "ggfocus_size")
})
