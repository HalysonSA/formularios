import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Produtos"),
          ),
          body: MyFormWidget(),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}

class NewNavBar extends HookWidget {
  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(onTap: botaoFoiTocado, items: const [
      BottomNavigationBarItem(
        label: "Produtos",
        icon: Icon(Icons.list_alt),
      ),
      BottomNavigationBarItem(
          label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
      BottomNavigationBarItem(label: "Nações", icon: Icon(Icons.flag_outlined))
    ]);
  }
}

class MyFormWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = useTextEditingController();
    final _descriptionController = useTextEditingController();
    final List<String> _genderOptions = ['Perecivel', 'Não perecivel'];
    final _genderController = useState<String>('');
    final _currentSliderValue = useState<double>(20);

    final _areFieldsEmpty = useState<bool>(true);

    bool areaFieldsEmpty() {
      return _nameController.text.isEmpty ||
          _descriptionController.text.isEmpty;
    }

    useEffect(() {
      _areFieldsEmpty.value = areaFieldsEmpty();
    }, [_nameController.value, _descriptionController.value]);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nome",
                hintText: "Digite o nome do produto",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Descrição",
                hintText: "Digite a descrição do produto",
              ),
            ),
          ),
          Slider(
            value: _currentSliderValue.value,
            max: 100,
            divisions: 5,
            label: _currentSliderValue.value.round().toString(),
            onChanged: (double value) {
              _currentSliderValue.value = value;
            },
          ),
          Column(
            children: _genderOptions.map((gender) {
              return RadioListTile(
                title: Text(gender),
                value: gender,
                groupValue: _genderController.value,
                onChanged: (value) {
                  _genderController.value = value.toString();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          _areFieldsEmpty.value
              ? ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width * 0.9, 50))),
                  child:
                      const Text('Adicionar', style: TextStyle(fontSize: 20)))
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final String name = _nameController.text;
                      final String description = _descriptionController.text;
                      final String opcao = _genderController.value;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                              'Produto adicionado com sucesso! Nome: $name, Descrição: $description e Opção: $opcao'),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width * 0.9, 50))),
                  child:
                      const Text('Adicionar', style: TextStyle(fontSize: 20)))
        ],
      ),
    );
  }
}
