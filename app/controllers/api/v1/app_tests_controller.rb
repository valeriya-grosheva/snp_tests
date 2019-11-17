# frozen_string_literal: true

module Api
  module V1
    class AppTestsController < ApiController
      before_action :check_scope_key_exists, only: %i[create index]

      def create
        outcome = AppTests::Create.run(test_params)
        render_single_outcome(outcome, TestSerializer)
      end

      def update
        app_test = AppTest.find_by(id: params[:id])

        raise Exceptions::NotFound unless app_test

        verify_scope_key(app_test.scope_key)
        outcome = AppTests::Update.run(test_params_update(app_test))
        render_single_outcome(outcome, TestSerializer)
      end

      def destroy
        app_test = AppTest.find_by(id: params[:id])

        raise Exceptions::NotFound unless app_test

        verify_scope_key(app_test.scope_key)

        app_test.destroy
        render_destroy_success
      end

      def index
        tests = AppTest.where(scope_key: scope_key)

        render json: tests, each_serializer: TestSerializer
      end

      def show
        app_test = AppTest.find_by(id: params[:id])

        raise Exceptions::NotFound unless app_test

        verify_scope_key(app_test.scope_key)

        render json: app_test, serializer: TestSerializer
      end

      private

      def test_params
        {
          title: params[:title],
          scope_key: scope_key,
        }
      end

      def test_params_update(app_test)
        {
          app_test: app_test,
          title: params[:title],
        }
      end
    end
  end
end