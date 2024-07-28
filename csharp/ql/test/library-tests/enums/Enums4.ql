/**
 * @name Test for enums
 */

import csharp

where forall(Enum e | e.getBaseClass().hasFullyQualifiedName("System", "Enum"))
select 1
