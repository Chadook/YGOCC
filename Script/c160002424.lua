--Carole, Onuncu Girl of Fiber Vine
function c160002424.initial_effect(c)
	c:EnableReviveLimit()

		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c160002424.condition2)
	e1:SetOperation(c160002424.operation2)
	c:RegisterEffect(e1)
		--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.ritlimit)
	c:RegisterEffect(e2)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c160002424.efilter)
	c:RegisterEffect(e4)
	
end

function c160002424.mat_filter(c)
	return not c:IsCode(160002424)
end


function c160002424.condition2(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_RITUAL and c:GetMaterial():IsExists(c160002424.pmfilter,1,nil)
end
function c160002424.pmfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x785b) and  c:IsType(TYPE_MONSTER) and not c:IsCode(160003232)
end
function c160002424.operation2(e,tp,eg,ep,ev,re,r,rp)
	--Negate
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(160002424,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c160002424.negcon)
	e2:SetCost(c160002424.negcost)
	e2:SetTarget(c160002424.negtg)
	e2:SetOperation(c160002424.negop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e2)
		--Special Summon
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetDescription(aux.Stringid(160002424,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c160002424.descon)
	e5:SetTarget(c160002424.destg)
	e5:SetOperation(c160002424.desop)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e5)
end
function c160002424.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c160002424.cfilter(c)
	return c:IsSetCard(0x785b) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c160002424.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c160002424.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c160002424.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re)then
		Duel.SendtoGrave(eg,REASON_RULE)
	end
end
function c160002424.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c160002424.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetPreviousControler()==tp
end

function c160002424.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c160002424.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end