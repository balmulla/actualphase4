require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  
    setup do 
      create_employees
    end
    
    # and provide a teardown method as well
    teardown do
      remove_employees
    end

    test "should get index" do
      get employees_url
      assert_response :success
    end

    test "should get new" do
      get new_employee_url
      assert_response :success
    end

    test "should create employee" do
      assert_difference('Employee.count') do
        post employees_url, params: { employee: { active: @alex.active, date_of_birth: @alex.date_of_birth, first_name: @alex.first_name, last_name: @alex.last_name, phone: @alex.phone, role: @alex.role, ssn: "123456789" } }
      end

      assert_redirected_to employee_url(Employee.last)
    end
    
    test "should not create employee" do
      # assert_equal('Employee.count', 5) do
      post employees_url, params: { employee: { active: @alex.active, date_of_birth: @alex.date_of_birth, first_name: @alex.first_name, last_name: @alex.last_name, phone: @alex.phone, role: @alex.role, ssn: @alex.role } }
      # end
      assert_equal(Employee.count, 6)

    end

    test "should show employee" do
      get employee_url(@alex)
      assert_response :success
    end

    test "should get edit" do
      get edit_employee_url(@alex)
      assert_response :success
    end

    test "should update employee" do
      patch employee_url(@alex), params: { employee: { active: @alex.active, date_of_birth: @alex.date_of_birth, first_name: @alex.first_name, last_name: @alex.last_name, phone: @alex.phone, role: @alex.role, ssn: @alex.ssn } }
      assert_redirected_to employee_url(@alex)
    end
    
    test "should not update employee" do
      patch employee_url(@alex), params: { employee: { active: @alex.active, date_of_birth: @alex.date_of_birth, first_name: @alex.first_name, last_name: @alex.last_name, phone: "1", role: @alex.role, ssn: @alex.ssn } }
      assert_not_equal(@alex.phone, "1")
    end

    test "should destroy employee" do
      assert_difference('Employee.count', -1) do
        delete employee_url(@alex)
      end

      assert_redirected_to employees_url
    end
end
