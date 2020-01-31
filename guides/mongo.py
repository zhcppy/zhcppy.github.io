import pymongo
import logging


class MongoDb:

    def __init__(self, db_name, col_name='test'):
        client = pymongo.MongoClient('mongodb://localhost:27017')
        db_list = client.list_database_names()
        if db_name in db_list:
            logging.info('database: %s is exist', db_name)
        self.db = client[db_name]

        col_list = self.db.list_collection_names()
        if col_name in col_list:
            logging.info('database: %s, collection: %s is exist', self.db.name, col_name)
        self.cur_collection = self.db[col_name]

    def set_collection(self, col_name):
        self.cur_collection = self.db[col_name]

    def insert(self, data):
        if self.cur_collection is None:
            raise NameError('please call set_collection() first')
        if isinstance(data, list):
            x = self.cur_collection.insert_many(data)
            logging.debug('insert many collection: %s, document: %s', self.cur_collection.name, x.inserted_ids)
        else:
            x = self.cur_collection.insert_one(data)
            logging.debug('insert one collection: %s, document: %s', self.cur_collection.name, x.inserted_id)

    def find(self):
        # self.cur_collection.find().sort()
        return self.cur_collection.find_one()


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)

    mongo = MongoDb('zhcppy', 'user')
    # mongo.set_collection('user')
    mongo.insert({"name": "zhanghang"})
    logging.debug(mongo.find())
