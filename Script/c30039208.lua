--Levelution Ac-Cell-eration
local ref=_G['c'..30039208]
function c30039208.initial_effect(c)
	c:EnableCounterPermit(0x12F)
	
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c30039208.ctcon)
	e2:SetOperation(c30039208.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x12F))
	e4:SetValue(c30039208.atkval)
	c:RegisterEffect(e4)
	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(ref.reptg)
	e2:SetValue(ref.repval)
	e2:SetOperation(ref.repop)
	c:RegisterEffect(e2)
	end
	
function c30039208.triggerfilter(c)
return not Duel.IsExistingMatchingCard(c30039208.lvfilter,c:GetControler(),LOCATION_MZONE,0,1,c,c:GetLevel())
end
	
function c30039208.lvfilter(c,lv)
	return c:IsFaceup() and c:GetLevel()>=lv
end

function c30039208.setfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12F)
	end

function c30039208.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30039208.triggerfilter,1,nil) and eg:IsExists(c30039208.setfilter,1,nil)
	end

function c30039208.ctop(e,tp,eg,ep,ev,re,r,rp)
 	e:GetHandler():AddCounter(0x12F,1)
	end

function c30039208.atkval(e,c)
	return e:GetHandler():GetCounter(0x12F)*200
end

--Destruction Replace
function ref.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x12F)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function ref.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(ref.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(30039210,0))
end
function ref.repval(e,c)
	return ref.repfilter(c,e:GetHandlerPlayer())
end
function ref.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end