--Garbage Gardna
function c8914277.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8914277,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c8914277.condition)
	e1:SetCost(c8914277.cost)
	e1:SetOperation(c8914277.operation)
	c:RegisterEffect(e1)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c8914277.xyzlimit)
	c:RegisterEffect(e3)
end
function c8914277.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x71a) or (c:IsCode(18698739) or c:IsCode(44682448)) or c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
end
function c8914277.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c8914277.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c8914277.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c8914277.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c8914277.filter)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function c8914277.filter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x71a) or c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
end
function c8914277.xyzlimit(e,c)
if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_DARK)
end