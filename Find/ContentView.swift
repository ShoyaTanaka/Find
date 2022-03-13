//
//  ContentView.swift
//  Find
//
//

import SwiftUI

struct ContentView: View {
    var userD:UserDefaults?
    
    @State var ext:[String] = UserDefaults(suiteName: "com.lightning.Find")!.array(forKey: "typeArray") as! [String]
    @State var Texa:[Tex] = {() -> [Tex] in
        var tmp:[Tex] = []
        let currentDefaults = UserDefaults(suiteName: "com.lightning.Find")!.array(forKey: "typeArray") as! [String]
        print("currentDefaults:\(currentDefaults)")
        for k in (0..<currentDefaults.count){
            tmp.append(Tex(tex: currentDefaults[k], num: k))
        }
        print(tmp)
        return tmp
    }()
    init(){
    print(Texa.count)
    userD = UserDefaults(suiteName: "com.lightning.Find")
    print("inited:\(ext)")
    }
    var body: some View {
        /*ForEach(Texa.indices,id:\.self){ num in
            HStack{
            Text(Texa[num].text.Field.stringValue)
            Text("\(num)")
            }
        }*/
        
        Button("Append") {
            self.ext = UserDefaults(suiteName: "com.lightning.Find")!.array(forKey: "typeArray") as! [String]
            self.ext.append("")
            self.Texa.append(Tex(tex:"",num:self.ext.count - 1))
            self.userD!.set(self.ext,forKey: "typeArray")
        }
        List{
            
            ForEach(self.Texa.indices,id:\.self) {num in
                HStack{
                    Texa[num]
                    Text("\(num)")

                    Button("Delete"){
                        if (tog){
                            self.ext = userD!.array(forKey: "typeArray") as! [String]
                        print("deletenum?:"+String(num))

                        self.ext.remove(at: num)
                        userD!.set(self.ext,forKey: "typeArray")
                        
                            tog.toggle()
                        
                        window.contentView = NSHostingView(rootView: ContentView())
                        print("修正後:\(self.Texa)")
                        
                        }
                        else {
                            tog.toggle()
                        }
                    }
                    
                }
            
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Tex:NSViewRepresentable {
    var text:texF
    init(tex:String,num:Int){
        self.text = texF(text:tex,num:num)
    }
    func updateNSView(_ nsView: NSTextField, context: Context){
        
    }
    func makeNSView(context: Context) -> NSTextField {
        return text.Field
    }

}
class texF:NSObject,NSTextFieldDelegate {
    var Field:NSTextField
    var num:Int
    var userD = UserDefaults(suiteName: "com.lightning.Find")
    init(text:String,num:Int){
        self.Field = NSTextField()
        self.Field.stringValue = text
        self.num = num
        super.init()
        self.Field.delegate = self
    }
    deinit{
        print("deinitialized.")
    }
    func controlTextDidChange(_ obj: Notification) {
        var arr = userD!.array(forKey: "typeArray") as! [String]
        let current = self.num
        if arr.count - 1 < self.num{
            arr.append(Field.stringValue)
        }
        else {
            arr[self.num] = Field.stringValue
        }
        userD!.set(arr,forKey: "typeArray")
        print("set")
    }
}


