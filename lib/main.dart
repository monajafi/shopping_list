import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      home: ShoppingList(
        products: <Product>[
          Product(name: "Eggs"),
          Product(name: "Flour"),
          Product(name: "Chocolate Chips"),
        ],
      )
    );
  }
}

class Product {
  final String name;
  const Product({this.name});
}

typedef CartChangedCallback = void Function(Product product,bool inCart);

class ShoppingListItem extends StatelessWidget {
  final bool inCart;
  final Product product;
  final CartChangedCallback onCartChanged;

  ShoppingListItem({Product product,this.inCart, this.onCartChanged}) 
         : product = product ,super(key: ObjectKey(product));
  
  Color _getColor(BuildContext context){
    return inCart ? Colors.black54: Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context){
    if(!inCart) return null;
    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough
    );
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onCartChanged(product,inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(
        product.name,
        style: _getTextStyle(context),
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  final List<Product> products;

  ShoppingList({Key key, this.products}) : super(key: key);

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = Set<Product>();

  void _handleCartChanged(Product product,bool inCart){
    setState(() {
     if (!inCart) {
       _shoppingCart.add(product);
     } else {
       _shoppingCart.remove(product);
     } 
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping List"),),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product){
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}
  