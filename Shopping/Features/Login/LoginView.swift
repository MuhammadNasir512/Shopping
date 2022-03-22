import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: ViewModel
    @State var userName: String = ""
    @State var password: String = ""

    var body: some View {
        VStack {
            LoginHeader(titleText: viewModel.loginHeaderText)
            TextField(viewModel.usernamePlaceholder, text: $userName)
                .padding()
                .cornerRadius(5.0)
                .border(.gray, width: 1)
                .padding()
            SecureField(viewModel.passwordPlaceholder, text: $password)
                .padding()
                .cornerRadius(5.0)
                .border(.gray, width: 1)
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            Button(action: {
                viewModel.doLogin(userName: userName, password: password)
            }) {
                LoginButton(titleText: viewModel.loginButtonTitleText)
            }
            .disabled(viewModel.isLoading)
            .alert(isPresented: $viewModel.needsShowingErrorAlert) {
                Alert(title: Text(viewModel.error?.localizedDescription ?? "Unknown Error"))
            }
        }
        .overlay(ProgressView().background(.white).opacity(viewModel.isLoading ? 1 : 0))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LoginView.ViewModel()
        LoginView(viewModel: viewModel)
    }
}

struct LoginHeader: View {
    let titleText: String
    var body: some View {
        return Text(titleText)
            .font(.largeTitle)
            .fontWeight(.semibold)
    }
}

struct LoginButton: View {
    let titleText: String
    var body: some View {
        return Text(titleText)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 150, height: 40)
            .background(Color.green)
            .cornerRadius(15.0)
            .padding(.top, 16)
    }
}
