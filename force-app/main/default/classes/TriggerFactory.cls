public with sharing class TriggerFactory {
	public static void createAndExecuteHandler(Type t) {
		ITrigger handler = getHandler(t);

		if (handler == null) {
			throw new TriggerException('No Trigger Handler found named: ' + t.getName());
		}

		execute(handler);
	}

	private static void execute(ITrigger handler) {
		if (Trigger.isBefore) {
			handler.bulkBefore();

			if (Trigger.isDelete) {
				for (SObject so : Trigger.old) {
					handler.beforeDelete(so);
				}
			} else if (Trigger.isInsert) {
				for (SObject so : Trigger.new) {
					handler.beforeInsert(so);
				}
			} else if (Trigger.isUpdate) {
				for (SObject so : Trigger.old) {
					handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
		} else {
			handler.bulkAfter();

			if (Trigger.isDelete) {
				for (SObject so : Trigger.old) {
					handler.afterDelete(so);
				}
			} else if (Trigger.isInsert) {
				for (SObject so : Trigger.new) {
					handler.afterInsert(so);
				}
			} else if (Trigger.isUpdate) {
				for (SObject so : Trigger.old) {
					handler.afterUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
		}

		handler.andFinally();
	}

	private static ITrigger getHandler(Type t) {
		Object o = t.newInstance();

		if (!(o instanceOf ITrigger)) {
		    return null;
		}

		return (ITrigger)o;
	}
}