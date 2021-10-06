(ns example-all-fail-test
  (:require example-all-fail
            [cljs.test :refer [deftest testing is] :as t :include-macros true]))

(deftest year-not-divisible-by-4
  (testing "Testing, year not divisible by four..."
    (is (not (example-all-fail/leap-year? 2999)))))

(deftest year-divisible-by-2-but-not-4
  (testing "Testing, year divisible by two but not four..."
    (is (not (example-all-fail/leap-year? 1658)))))

(deftest year-divisible-by-4-but-not-100
  (testing "Testing, year divisible by four but not one hundred..."
    (is (example-all-fail/leap-year? 2004))))

(deftest year-divisible-by-4-and-5
  (testing "Testing, year divisible by four and five..."
    (is (example-all-fail/leap-year? 2020))))

(deftest year-divisible-by-100-but-not-400
  (testing "Testing, year divisible by one hundred but not four hundred..."
    (is (not (example-all-fail/leap-year? 2200)))))

(deftest year-divisible-by-100-but-not-by-3
  (testing "Testing, year divisible by one hundred by not by three..."
    (is (not (example-all-fail/leap-year? 2500)))))

(deftest year-divisible-by-400
  (testing "Testing, year divisible by four hundred..."
    (is (example-all-fail/leap-year? 2800))))

(deftest year-divisible-by-400-but-not-125
  (testing "Testing, year divisible by four hundred but not one hundred twenty five..."
    (is (example-all-fail/leap-year? 3200))))

(deftest year-divisible-by-200-but-not-by-400
  (testing "Testing, year divisible by two hundred but not by four hundred..."
    (is (not (example-all-fail/leap-year? 2900)))))
