import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map'


@Injectable()
export class SaleService {

  constructor(private http: Http) { }

  buyProduct(user_id, product_id){
    let body = { user_id: user_id, product_id: product_id }
    let headers = new Headers({ 'ContentType': 'application/json' });
    let body = new RequestOptions({ headers: headers });
  
    return this.http.post('http://192.168.99.101:4000/buy', body, options).map((response: Response) => {
      console.log(response.json());
      response.json();
     })
  }

}
